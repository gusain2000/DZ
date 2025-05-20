namespace FTP1;
using System.Net;
using System.Net.Mail;


public class Sender
{
    private string smtpHost = "smtp.gmail.com";
    private int smtpPort = 587;
    private string smtpUser = "gusain208@gmail.com";
    private string smtpPass = "poka skroyu";

    public void Send(Messager message)
    {
        var mail = new MailMessage(message.From, message.To, message.Subject, message.Body);
        var client = new SmtpClient(smtpHost, smtpPort)
        {
            Credentials = new NetworkCredential(smtpUser, smtpPass),
            EnableSsl = true
        };

        try
        {
            Console.WriteLine("Отправка сообщения...");
            client.Send(mail);
            Console.WriteLine("Письмо отправлено успешно.");
        }
        catch (Exception ex)
        {
            Console.WriteLine("Ошибка: " + ex.Message);
        }
    }
}