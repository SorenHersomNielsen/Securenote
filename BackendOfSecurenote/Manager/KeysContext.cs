using BackendOfSecurenote.Models;
using Microsoft.EntityFrameworkCore;

namespace BackendOfSecurenote.Manager
{
	public class KeysContext : DbContext
	{
		public KeysContext(DbContextOptions<KeysContext> options) : base(options)
		{
		}

		public DbSet<Keys> keys { get; set; }
	}
}

