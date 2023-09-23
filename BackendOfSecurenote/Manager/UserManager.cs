using BackendOfSecurenote.Models;

namespace BackendOfSecurenote.Manager
{
	public class UserManager
	{

		private readonly UserContext _context;
		private readonly IConfiguration _configuration;
	
        public UserManager(UserContext context, IConfiguration configuration)
		{
			_context = context;
            _configuration = configuration;
        }


        public UserManager()
		{
		}

		public UserResponse signin(Signin signin)
		{
			User checkuserexist = _context.user.SingleOrDefault(x => x.Username == signin.username && x.Password == signin.password);
			if (checkuserexist == null)
			{
				return null;
			}
			int userid = checkuserexist.Id;

            JWTManager jWTManager = new JWTManager(_configuration);

            string generatedToken = jWTManager.Autenticate(checkuserexist.Id.ToString());

			return new UserResponse { token = generatedToken, userid = userid };


        }

        public UserResponse AddUser(User user)
		{
			bool checkUsername = _context.user.Any(x => x.Username == user.Username);
			if (checkUsername == false)
			{
                _context.user.Add(user);
                _context.SaveChanges();

				JWTManager jWTManager = new JWTManager(_configuration);

				int id = user.Id;

				string generatedToken = jWTManager.Autenticate(user.Id.ToString());

				return new UserResponse { token = generatedToken, userid = id };
            }
			return null;
		}
	}
}

