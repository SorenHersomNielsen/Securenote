using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BackendOfSecurenote.Manager;
using BackendOfSecurenote.Models;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BackendOfSecurenote.Controllers
{
    [Route("api/[controller]")]
    public class NoteController : Controller
    {
        private readonly NoteManager _manager;
        public NoteController(NoteContext context)
        {
            _manager = new NoteManager(context);
        }

        // GET: api/values
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public IEnumerable<Note> Get()
        {
            return _manager.GetAllNotes();
        }


        // POST api/values
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Note> Post([FromBody] Note value)
        {
            try
            {
                Note newNote = _manager.AddNote(value);
                string uri = Url.RouteUrl(RouteData.Values) + "/" + newNote.Id;
                return Created(uri, newNote);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Note> Put(int id, [FromBody]Note value)
        {
            try
            {
                Note updateNote = _manager.UpdateNote(id, value);
                if (updateNote == null)
                {
                    return NotFound(("No such Note, id:" + id));
                }
                return Ok(updateNote);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Note> DeleteNote(int id)
        {
            Note deletedNotes = _manager.DeleteNote(id);
            if (deletedNotes == null)
            {
                return NotFound("That does not exist note with that id");
            }
            return Ok(deletedNotes);
        }
    }
}

