
using System;
using System.Net.Sockets;
using System.Text;

class Client
{
    static void Main()
    {
        var client = new TcpClient("127.0.0.1", 13000);
        Console.WriteLine("Подключено к серверу.");
        var stream = client.GetStream();
        var buffer = new byte[1024];

        while (true)
        {
            Console.Write("Вы: ");
            string message = Console.ReadLine();
            byte[] data = Encoding.UTF8.GetBytes(message);
            stream.Write(data, 0, data.Length);
            
            int bytesRead = stream.Read(buffer, 0, buffer.Length);
            string response = Encoding.UTF8.GetString(buffer, 0, bytesRead);
            Console.WriteLine("Сервер: " + response);
        }
        
    }
}