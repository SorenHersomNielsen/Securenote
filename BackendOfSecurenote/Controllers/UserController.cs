using BackendOfSecurenote.Manager;
using BackendOfSecurenote.Models;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BackendOfSecurenote.Controllers
{
    [Route("api/[controller]")]
    public class UserController : Controller
    {
        private readonly UserManager _manager;
        public UserController(UserContext context, IConfiguration configuration)
        {
            _manager = new UserManager(context, configuration);
        }

        [HttpPost("signin")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<User> Post([FromBody] Signin signin)
        {
            try
            {
                UserResponse checkuser = _manager.signin(signin);
                if (checkuser == null)
                {
                    return NotFound();
                }
                string uri = Url.RouteUrl(RouteData.Values) + '/' + checkuser.token;
                return Created(uri, checkuser);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }
        // POST api/values
        [HttpPost("createuser")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status409Conflict)]
        public ActionResult<User> Post([FromBody] User user)
        {
            try
            {
                UserResponse checkuser = _manager.AddUser(user);
                if (checkuser == null)
                {
                    return Conflict();
                }
                string uri = Url.RouteUrl(RouteData.Values) + '/' + checkuser.token;
                return Created(uri, checkuser);
            }
            catch (ArgumentException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        // PUT api/values/5
        /*[HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }*/
    }
}

