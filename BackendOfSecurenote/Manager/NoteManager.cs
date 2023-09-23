using Microsoft.EntityFrameworkCore;
using BackendOfSecurenote.Models;
namespace BackendOfSecurenote.Manager
{
	public class NoteManager
	{
		private readonly NoteContext _context;
		public NoteManager(NoteContext context)
		{
			_context = context;
		}

		public NoteManager()
		{

		}

		public IEnumerable<Note> GetAllNotes(int userid)
		{

			return _context.note.Where(x => x.User_id.Equals(userid));
		}


		public Note AddNote(Note newnote)
		{
			_context.note.Add(newnote);
			_context.SaveChanges();
			return newnote;
		}

		public Note UpdateNote(int id, Note updates)
		{
			Note note = _context.note.Find(id);
			if (note == null)
			{
				return null;
			}

			note.Title = updates.Title;
			note.Text = updates.Text;
			_context.Entry(note).State = EntityState.Modified;
			_context.SaveChanges();
			return note;
		}

		public Note DeleteNote(int id)
		{
			Note note = _context.note.Find(id);
			if (note == null)
			{
				return null;
			}

			_context.note.Remove(note);
			_context.SaveChanges();
			return note;
		}
	}
}

