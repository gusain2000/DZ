
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

class Server
{
    static void Main()
    {
        var server = new TcpListener(IPAddress.Parse("127.0.0.1"), 13000);
        server.Start();
        Console.WriteLine("Сервер запущен. Ожидание клиента...");

        var client = server.AcceptTcpClient();
        Console.WriteLine("Клиент подключён.");

        var stream = client.GetStream();
        var buffer = new byte[1024];

        while (true)
        {
            int bytesRead = stream.Read(buffer, 0, buffer.Length);
            string message = Encoding.UTF8.GetString(buffer, 0, bytesRead);
            Console.WriteLine("Клиент: " + message);
            
            Console.Write("Я: ");
            string response = Console.ReadLine();
            byte[] responseBytes = Encoding.UTF8.GetBytes(response);
            stream.Write(responseBytes, 0, responseBytes.Length);
        }
    }
}