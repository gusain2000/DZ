using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Threading;

class Program
{
    static void Main()
    {
        Console.Title = "TCP Chat";

        Console.Write("Введите порт для прослушивания (например, 5000): ");
        int listenPort = int.Parse(Console.ReadLine());

        Console.Write("Введите IP собеседника: ");
        string remoteIp = Console.ReadLine();

        Console.Write("Введите порт собеседника: ");
        int remotePort = int.Parse(Console.ReadLine());
        Thread receiveThread = new Thread(() => StartServer(listenPort));
        receiveThread.IsBackground = true;
        receiveThread.Start();
        StartClient(remoteIp, remotePort);
    }

    static void StartServer(int port)
    {
        TcpListener listener = null;
        try
        {
            listener = new TcpListener(IPAddress.Any, port);
            listener.Start();
            Console.WriteLine($"[Сервер] Ожидание подключения на порту {port}...");

            while (true)
            {
                TcpClient client = listener.AcceptTcpClient();
                Thread clientThread = new Thread(() => HandleClient(client));
                clientThread.IsBackground = true;
                clientThread.Start();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[Сервер] Ошибка: {ex.Message}");
        }
        finally
        {
            listener?.Stop();
        }
    }

    static void HandleClient(TcpClient client)
    {
        using var reader = new StreamReader(client.GetStream());
        try
        {
            string message;
            while ((message = reader.ReadLine()) != null)
            {
                Console.ForegroundColor = ConsoleColor.Cyan;
                Console.WriteLine($"\n[Собеседник]: {message}");
                Console.ResetColor();
                Console.Write("> ");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[Сервер] Ошибка при приеме: {ex.Message}");
        }
    }

    static void StartClient(string ip, int port)
    {
        while (true)
        {
            try
            {
                using TcpClient client = new TcpClient();
                client.Connect(ip, port);
                Console.WriteLine($"[Клиент] Подключено к {ip}:{port}");
                using var writer = new StreamWriter(client.GetStream()) { AutoFlush = true };

                while (true)
                {
                    Console.Write("> ");
                    string message = Console.ReadLine();
                    writer.WriteLine(message);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[Клиент] Ошибка подключения: {ex.Message}");
                Thread.Sleep(1500);
            }
        }
    }
}
