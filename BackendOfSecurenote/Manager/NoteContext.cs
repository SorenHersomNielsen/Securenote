using BackendOfSecurenote.Models;
using Microsoft.EntityFrameworkCore;
namespace BackendOfSecurenote.Manager
{
	public class NoteContext : DbContext
	{
		public NoteContext(DbContextOptions<NoteContext> options) : base(options)
		{
		}

		public DbSet<Note> note { get; set; }
	}
}

