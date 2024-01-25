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

            JWTManager jWTManager = new JWTManager(_configuration, _context);

            string generatedToken = jWTManager.Autenticate(checkuserexist.Id.ToString());

			return new UserResponse { token = generatedToken, userid = userid };


        }

        public UserResponse AddUser(User user)
		{
			var checkuser = _context.user.Where(u => u.Username == user.Username).FirstOrDefault();
            if (checkuser == null)
			{
                _context.user.Add(user);
                _context.SaveChanges();

				JWTManager jWTManager = new JWTManager(_configuration, _context);

				int id = user.Id;

				string generatedToken = jWTManager.Autenticate(user.Id.ToString());


               return new UserResponse { token = generatedToken, userid = id};
            }
			return null;
		}
    }
}

