using System;
using System.Linq;
using BackendOfSecurenote.Models;

namespace BackendOfSecurenote.Manager
{
	public class KeyManager
	{
		private readonly KeysContext _context;
		public KeyManager(KeysContext context)
		{
			_context = context;
		}

		public KeyManager()
		{

		}

		public string getkey(int userid)
		{
			Keys key = _context.keys.SingleOrDefault(x => x.user_id == userid);
			if (key == null)
			{
				return null;
			}
			string userkey = key.key;

			return userkey;

        }

		public Keys AddKey(Keys key)
		{
			_context.keys.Add(key);
			_context.SaveChanges();
			return key;
		}
	}
}

