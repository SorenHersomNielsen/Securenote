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
            audience: id,
            claims: claims,
            expires: DateTime.Now.AddHours(1),
            signingCredentials: creads);

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        public int? decodenamefromtoken(string token)
        {

            string newtoken = token.Replace("Bearer ", "");
            var tokenhandler = new JwtSecurityTokenHandler();

            var jwttoken = tokenhandler.ReadJwtToken(newtoken);

            JwtPayload payload = jwttoken.Payload;

            string iss = payload.Iss;

            string wordiss = "SecureNote";

            bool checkiss = wordiss.Equals(iss);

            if (checkiss == true)
            {
                int? expires = payload.Exp;

                if (expires == null)
                {
                    return null;
                }

                int converint = converttointfromint(expires);

                DateTimeOffset dateTimeOffset = DateTimeOffset.FromUnixTimeSeconds(converint).ToLocalTime();

                DateTime dateTime = dateTimeOffset.DateTime;

                if (DateTime.Now > dateTime)
                {
                    return null;
                }

                var ilist = payload.Aud;

                string userid = ilist.ElementAt(0);

                if (userid == null)
                {
                    return null;
                }

                int converttoint = int.Parse(userid);

                User user = _context.user.SingleOrDefault(x => x.Id == converttoint);
                if (user == null)
                {
                    return null;
                }

                int id = user.Id;

                return id;

            }

            return null;
        }

        public int converttointfromint(int? @int)
        {
            int converttointfromint = @int.GetValueOrDefault();

            return converttointfromint;
        }
    }
}

