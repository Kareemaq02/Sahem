﻿using Application.Core;
using MediatR;
using MySqlX.XDevAPI.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application
{
    public record DeleteComplaintTypeByIdCommand(int Id, string username) : IRequest<Result<string>>;
}
