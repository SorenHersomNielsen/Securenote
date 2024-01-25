using BackendOfSecurenote.Manager;
using BackendOfSecurenote.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BackendOfSecurenote.Controllers
{
    [RequireHttps]
    [Route("api/[controller]")]
    public class NoteController : Controller
    {
        private readonly NoteManager _manager;
        private readonly JWTManager _jWTManager;
        private readonly UserManager _userManager;
        public NoteController(NoteContext context, IConfiguration configuration, UserContext userContext)
        {
            _manager = new NoteManager(context);
            _jWTManager = new JWTManager(configuration, userContext);
       
        }

        // GET: api/values
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public ActionResult<Note> Get(int userid)
        {
            string Authorization = HttpContext.Request.Headers["Authorization"].ToString();

            int? jwt = _jWTManager.decodenamefromtoken(Authorization);

            if (jwt == null)
            {
                return Unauthorized();
            }

            try
            {
                IEnumerable<Note> notes = _manager.GetAllNotes(userid);

                return Ok(notes);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        
        // POST api/values
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public ActionResult<Note> Post([FromBody] Note value)
        {
            string Authorization = HttpContext.Request.Headers["Authorization"].ToString();

            int? jwt = _jWTManager.decodenamefromtoken(Authorization);

            if (jwt == null)
            {
                return Unauthorized();
            }

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
            string Authorization = HttpContext.Request.Headers["Authorization"].ToString();

            int? jwt = _jWTManager.decodenamefromtoken(Authorization);

            if (jwt == null)
            {
                return Unauthorized();
            }

            try
            {
                Note updateNote = _manager.UpdateNote(id, value);
                if (updateNote == null)
                {
                    return NotFound("No such Note, id:" + id);
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
            string Authorization = HttpContext.Request.Headers["Authorization"].ToString();

            int? jwt = _jWTManager.decodenamefromtoken(Authorization);

            if (jwt == null)
            {
                return Unauthorized();
            }

            int converttoint = _jWTManager.converttointfromint(jwt);

            int deletedNotes = _manager.DeleteNote(id, converttoint);

            if (deletedNotes == 404)
            {
                return NotFound("That does not exist note with that id");
            }
            return Ok(deletedNotes);
        } 
    }
}

