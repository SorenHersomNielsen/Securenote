using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using BackendOfSecurenote.Models;

namespace BackendOfSecurenote.Manager
{
	public class JWTManager : IJWTManager
	{
        private readonly IConfiguration _configuration;
        private readonly UserContext _context;
		public JWTManager(IConfiguration configuration)
		{
            _configuration = configuration;
		}

        public JWTManager(IConfiguration configuration, UserContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        public string Autenticate(string id)
        {
            List<Claim> claims = new List<Claim>
            {
               new Claim(ClaimTypes.Name, id)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection("AppSettings:Token").Value!));

            var creads = new SigningCredentials(key, SecurityAlgorithms.HmacSha256Signature);

            var token = new JwtSecurityToken(
            issuer: "SecureNote",
            audience: "SecureNote",
            claims: claims,
            expires: DateTime.Now.AddHours(1),
            signingCredentials: creads);

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        // may be used later, haven't decided yet
        /*public int decodenamefromtoken(string token)
        {
            var tokenhandler = new JwtSecurityTokenHandler();
            var jwttoken = tokenhandler.ReadJwtToken(token);

            var name = jwttoken.Claims.First(x => x.Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name");
            string namevalue = name?.Value;

            if (name == null)
            {
                return 0;
            }

            if (!int.TryParse(namevalue, out int converttoint))
            {
                return 0;
            }

            User user = _context.user.Find(converttoint);
            if (user == null)
            {
                return 0;
            }
            int userid = user.Id;
            return userid;
           
        }*/
    }
}

