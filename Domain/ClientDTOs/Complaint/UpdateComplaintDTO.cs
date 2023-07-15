using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Domain.ClientDTOs.Complaint
{
    public class UpdateComplaintDTO
    {
        [JsonIgnore]
        public string strUserName { get; set; }
        public string strComplaintTypeEn { get; set; }
        public string strComment { get; set; }
    }
}
