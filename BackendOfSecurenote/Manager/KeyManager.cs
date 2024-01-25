using BackendOfSecurenote.Models;

namespace BackendOfSecurenote.Manager
{
	public class KeyManager
	{
		private readonly KeysContext _context;
        private readonly UserContext userContext;
        public KeyManager(KeysContext context, UserContext userContext1)
		{
			_context = context;
			userContext = userContext1; 
		}

		public KeyManager()
		{

		}

		public Keys getkey(int userid)
		{
			Keys key = _context.keys.SingleOrDefault(x => x.user_id == userid);
			if (key == null)
			{
				return null;
			}

			return key;

        }

		public Keys getKeyByusername(string username)
		{
            User checkuser = userContext.user.Where(u => u.Username == username).FirstOrDefault();
			if (checkuser != null)
			{
                Keys key = _context.keys.SingleOrDefault(x => x.user_id == checkuser.Id);
				return key;
            }
			return null;
        }

		public Keys AddKey(Keys key)
		{
			_context.keys.Add(key);
			_context.SaveChanges();
			return key;
		}
	}
}

