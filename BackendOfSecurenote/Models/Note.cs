using System;
namespace BackendOfSecurenote.Models
{
	public class Note
	{
		public int Id { get; set; }
		public string Title { get; set; }
		public string Text { get; set; }
		public int User_id { get; set; }
	}
}

