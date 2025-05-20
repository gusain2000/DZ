using FTP1;

var message = new Messager()
{
    From = "gusain208@gmail.com",
    To = "hi4581101@gmail.com",
    Subject = "DFGDFG",
    Body = "123123"
};

var sender = new Sender();
sender.Send(message);