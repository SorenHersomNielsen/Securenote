using BackendOfSecurenote.Models;
using Microsoft.EntityFrameworkCore;

namespace BackendOfSecurenote.Manager
{
	public class UserContext : DbContext
	{
		public UserContext(DbContextOptions<UserContext> options) : base(options)
		{
		}

        public DbSet<User> user { get; set; }
	}
}
