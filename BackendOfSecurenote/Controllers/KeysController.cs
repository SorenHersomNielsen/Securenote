using BackendOfSecurenote.Manager;
using BackendOfSecurenote.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BackendOfSecurenote.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class KeysController : Controller
    {
        private readonly KeyManager _manager;
        public KeysController(KeysContext context)
        {
            _manager = new KeyManager(context);
        }

        // GET api/values/5
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public ActionResult<Keys> Get(int id)
        {
            Keys key = _manager.getkey(id);
            if (key == null)
            {
                return NotFound();
            }
            return Ok(key);
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public ActionResult<Keys> Post([FromBody] Keys value)
        {
            try
            {
                Keys newKey = _manager.AddKey(value);
                string uri = Url.RouteUrl(RouteData.Values) + "/" + newKey;
                return Created(uri, newKey);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}

