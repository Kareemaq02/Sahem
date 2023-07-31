using API.Services;
using Domain.ClientDTOs.User;
using Domain.DataModels.User;
using Domain.Resources;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.IdentityModel.Tokens;
using Persistence;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AccountController : ControllerBase
    {
        public readonly UserManager<ApplicationUser> _userManager;
        public readonly DataContext _context;
        private readonly TokenService _tokenService;

        public AccountController(
            UserManager<ApplicationUser> userManager,
            DataContext context,
            TokenService tokenService
        )
        {
            _userManager = userManager;
            _context = context;
            _tokenService = tokenService;
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(LoginDTO login)
        {
            ApplicationUser user;
            // Check if user used phonenumber or username for login
            if (login.strLogin.Length == 10 && login.strLogin.All(char.IsDigit))
            {
                user = await _context.ApplicationUsers
                    .Where(q => q.PhoneNumber == login.strLogin)
                    .FirstOrDefaultAsync();
            }
            else
            {
                user = await _userManager.FindByNameAsync(login.strLogin);
            }

            if (user == null)
                return Unauthorized("User doesn't exist.");

            var result = await _userManager.CheckPasswordAsync(user, login.strPassword);
            if (result)
            {
                user.UserInfo = await _context.UserInfos.FindAsync(user.Id);
                return _tokenService.CreateToken(user);
            }
            return Unauthorized("Password is not correct.");
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ActionResult<string>> Register(RegisterDTO register)
        {
            // If fails, return error code and stop executing
            var validation = await ValidateUserInput(register);
            if (validation is BadRequestObjectResult)
            {
                return validation;
            }

            // START TRANSACTION
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                EntityEntry<UserInfo> userInfo = await InsertUserInfo(register);
                await _context.SaveChangesAsync();

                // Query user type
                UserType userType = await _context.UserTypes
                    .Where(q => q.strName == ConstantsDB.UserTypes.User)
                    .FirstOrDefaultAsync();

                // Create User
                ApplicationUser user =
                    new()
                    {
                        UserName = register.strUsername.ToLower(),
                        intUserTypeId = userType.intId,
                        intUserInfoId = userInfo.Entity.intId,
                        UserInfo = userInfo.Entity
                    };

                var result = await _userManager.CreateAsync(user, register.strPassword);

                if (result.Succeeded)
                {
                    await transaction.CommitAsync();
                    return _tokenService.CreateToken(user);
                }

                // Rollback changes if failed
                await transaction.RollbackAsync();
                return BadRequest(result.Errors);
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                // Display error
                return BadRequest();
            }
        }
        [HttpPost("register/employee")]
        public async Task<ActionResult<string>> RegisterEmployee(RegisterDTO register, bool isAdmin)
        {
            // If fails, return error code and stop executing
            var validation = await ValidateUserInput(register);
            if (validation is BadRequestObjectResult)
            {
                return validation;
            }

            // START TRANSACTION
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                EntityEntry<UserInfo> userInfo = await InsertUserInfo(register);
                await _context.SaveChangesAsync();

                UserType userType;
                // Query user type
                if (isAdmin)
                {
                        userType = await _context.UserTypes
                        .Where(q => q.strName == ConstantsDB.UserTypes.Admin)
                        .FirstOrDefaultAsync();
                }
                else
                {
                             userType = await _context.UserTypes
                            .Where(q => q.strName == ConstantsDB.UserTypes.Worker)
                            .FirstOrDefaultAsync();
                }


                // Create User
                ApplicationUser user =
                    new()
                    {
                        UserName = register.strUsername.ToLower(),
                        intUserTypeId = userType.intId,
                        intUserInfoId = userInfo.Entity.intId,
                        UserInfo = userInfo.Entity
                    };

                var result = await _userManager.CreateAsync(user, register.strPassword);

                if (result.Succeeded)
                {
                    await transaction.CommitAsync();
                    return _tokenService.CreateToken(user);
                }

                // Rollback changes if failed
                await transaction.RollbackAsync();
                return BadRequest(result.Errors);
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                // Display error
                return BadRequest();
            }
        }

        [Authorize]
        [HttpPost("refresh")]
        public async Task<ActionResult<string>> RefreshToken()
        {
            var user = await _userManager.FindByNameAsync(User.FindFirstValue("username"));
            return _tokenService.CreateToken(user);
        }

        [Authorize]
        [HttpPut("update")]
        public async Task<ActionResult<string>> UpdateUserInfo(UserUpdateDTO userUpdateDTO)
        {
            string authHeader = Request.Headers["Authorization"];
            JwtSecurityTokenHandler tokenHandler = new();
            JwtSecurityToken jwtToken = tokenHandler.ReadJwtToken(authHeader[7..]);

            var strUserName = jwtToken.Claims.First(c => c.Type == "username").Value;
            var user = await _userManager.FindByNameAsync(strUserName);

            if (user == null)
            {
                return BadRequest("Bad security token.");
            }

            if (!string.IsNullOrWhiteSpace(userUpdateDTO.strNewUserName))
            {
                if (
                    await _userManager.Users.AnyAsync(
                        q => q.UserName == userUpdateDTO.strNewUserName
                    )
                )
                {
                    return BadRequest("Username is already used.");
                }

                user.UserName = userUpdateDTO.strNewUserName;
                user.NormalizedUserName = _userManager.NormalizeName(userUpdateDTO.strNewUserName);
            }

            if (!string.IsNullOrWhiteSpace(userUpdateDTO.strNewEmail))
            {
                if (await _userManager.Users.AnyAsync(q => q.Email == userUpdateDTO.strNewEmail))
                {
                    return BadRequest("Email is already used.");
                }

                user.Email = userUpdateDTO.strNewEmail;
                user.NormalizedEmail = _userManager.NormalizeName(userUpdateDTO.strNewEmail);
            }

            if (!string.IsNullOrWhiteSpace(userUpdateDTO.strNewPhoneNumber))
            {
                if (
                    await _context.UserInfos.AnyAsync(
                        q => q.strPhoneNumber == userUpdateDTO.strNewPhoneNumber
                    )
                )
                {
                    return BadRequest("Phonenumber is already used.");
                }

                var userInfo = await _context.UserInfos.FindAsync(user.intUserInfoId);
                userInfo.strPhoneNumber = userUpdateDTO.strNewPhoneNumber;
            }

            if (
                !string.IsNullOrWhiteSpace(userUpdateDTO.strNewPassword)
                && !string.IsNullOrWhiteSpace(userUpdateDTO.strOldPassword)
            )
            {
                var result = await _userManager.ChangePasswordAsync(
                    user,
                    userUpdateDTO.strOldPassword,
                    userUpdateDTO.strNewPassword
                );

                if (!result.Succeeded)
                {
                    return result.Errors.First().Description;
                }
            }

            if (!string.IsNullOrWhiteSpace(userUpdateDTO.strNewLocation))
            {
                // NOT IMPLEMENTED IN SYSTEM YET
            }

            using var transaction = await _context.Database.BeginTransactionAsync();
            {
                try
                {
                    await _userManager.UpdateAsync(user);
                    await _context.SaveChangesAsync();
                    transaction.Commit();
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    return StatusCode(500, "An error occurred while updating user information.");
                }
            }

            return _tokenService.CreateToken(user);
        }

        // Private Methods
        private async Task<ActionResult> ValidateUserInput(RegisterDTO register)
        {
            // Duplicate validation

            if (await _userManager.Users.AnyAsync(q => q.UserName == register.strUsername))
            {
                return BadRequest("Username is already used.");
            }

            if (await _context.UserInfos.AnyAsync(q => q.strPhoneNumber == register.strPhonenumber))
            {
                return BadRequest("Phonenumber is already used.");
            }

            if (
                register.strNationalId != null
                && await _context.UserInfos
                    .Where(q => q.strNationalId == register.strNationalId)
                    .FirstOrDefaultAsync() != null
            )
            {
                return BadRequest("National ID is already used.");
            }

            if (
                register.strNationalIdNumber != null
                && await _context.UserInfos
                    .Where(q => q.strNationalIdNumber == register.strNationalIdNumber)
                    .FirstOrDefaultAsync() != null
            )
            {
                return BadRequest("ID number is already used.");
            }

            if (
                register.strPassportNumber != null
                && await _context.UserInfos
                    .Where(q => q.strPassportNumber == register.strPassportNumber)
                    .FirstOrDefaultAsync() != null
            )
            {
                return BadRequest("Passport number is already used.");
            }
            ///

            return Ok();
        }

        private async Task<EntityEntry<UserInfo>> InsertUserInfo(RegisterDTO register)
        {
            return await _context.UserInfos.AddAsync(
                new UserInfo
                {
                    strFirstName = register.strFirstName.ToLower(),
                    strLastName = register.strLastName.ToLower(),
                    strPhoneNumber = register.strPhonenumber,
                    strNationalId = register.strNationalId,
                    strNationalIdNumber = register.strNationalIdNumber?.ToUpper(),
                    strPassportNumber = register.strPassportNumber?.ToUpper(),
                    strRegistrationNumber = register.strRegistrationNumber,
                }
            );
        }
    }
}
