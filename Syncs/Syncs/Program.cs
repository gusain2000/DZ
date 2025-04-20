
//Задание 3
using System;
using System.Threading;

/*class Program
{
    static void Main()
    {
        using (Mutex mutex = new Mutex(false, "MyAppMutex"))
        {
            if (mutex.WaitOne(TimeSpan.Zero, true))
            {
                for (int i = 1; i <= 3; i++)
                {
                    Console.WriteLine($"Копия {i} запущена.");
                    Thread.Sleep(5000);  
                }
                Console.WriteLine("Приложение завершено.");
            }
            else
            {
                Console.WriteLine("Приложение не может быть запущено более 3 раз.");
            }
        }
    }
}*/
//Задание 4,5
/*using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;

class Program
{
    static Mutex mutex = new Mutex();

    static void Main()
    {
        string file1 = "numbers.txt";
        string file2 = "simples.txt";
        string file3 = "simple7.txt";
        string reportFile = "report.txt";
        
        Thread t1 = new Thread(() => Generate(file1));
        Thread t2 = new Thread(() => Simple(file1, file2));
        Thread t3 = new Thread(() => Simple7(file2, file3));
        Thread t4 = new Thread(() => Report(new string[] { file1, file2, file3 }, reportFile));

        t1.Start();
        t1.Join();

        t2.Start();
        t2.Join();

        t3.Start();
        t3.Join();
        t4.Start();
        t4.Join();

        Console.WriteLine("Все потоки завершены.");
    }

    static void Generate(string filename)
    {
        Random rand = new Random();
        var numbers = Enumerable.Range(0, 100).Select(_ => rand.Next(1, 1000)).ToArray();
        mutex.WaitOne();
        File.WriteAllLines(filename, numbers.Select(n => n.ToString()));
        mutex.ReleaseMutex();
    }

    static void Simple(string inputFile, string outputFile)
    {
        var numbers = File.ReadAllLines(inputFile).Select(int.Parse);
        var primes = numbers.Where(IsPrime).ToArray();
        mutex.WaitOne();
        File.WriteAllLines(outputFile, primes.Select(p => p.ToString()));
        mutex.ReleaseMutex();
    }

    static void Simple7(string inputFile, string outputFile)
    {
        var primes = File.ReadAllLines(inputFile).Select(int.Parse);
        var primesWith7 = primes.Where(p => p % 10 == 7).ToArray();
        mutex.WaitOne();
        File.WriteAllLines(outputFile, primesWith7.Select(p => p.ToString()));
        mutex.ReleaseMutex();
    }

    static bool IsPrime(int n)
    {
        if (n < 2) return false;
        for (int i = 2; i <= Math.Sqrt(n); i++)
        {
            if (n % i == 0) return false;
        }
        return true;
    }

    static void Report(string[] files, string reportFile)
    {
        var report = new StringBuilder();

        foreach (var file in files)
        {
            var content = File.ReadAllLines(file);
            var size = new FileInfo(file).Length;
            report.AppendLine($"Файл: {file}");
            report.AppendLine($"Количество чисел: {content.Length}");
            report.AppendLine($"Размер файла: {size} байт");
            report.AppendLine($"Содержимое файла:\n{string.Join(", ", content)}\n");
        }

        File.WriteAllText(reportFile, report.ToString());
        Console.WriteLine("Отчет создан.");
    }
}*/
//Задание 6
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;

class Program
{
    static object locker = new object();
    static Random rand = new Random();
    static int playersServed = 0;
    static int totalPlayers;

    static List<string> report = new List<string>();

    static void Main()
    {
        totalPlayers = rand.Next(20, 101); // от 20 до 100

        Console.WriteLine($"Сегодня к игре готовы {totalPlayers} игроков.");

        List<Thread> threads = new List<Thread>();

        for (int i = 0; i < 5; i++)
        {
            threads.Add(new Thread(Play));
            threads[i].Start();
        }

        foreach (var t in threads)
        {
            t.Join();
        }

        File.WriteAllLines("casino_report.txt", report);
        Console.WriteLine("Работа казино завершена. Отчет сохранен в 'casino_report.txt'.");
    }

    static void Play()
    {
        while (true)
        {
            int playerNumber;

            lock (locker)
            {
                if (playersServed >= totalPlayers) break;
                playerNumber = playersServed + 1;
                playersServed++;
            }

            int money = rand.Next(100, 501);
            int startMoney = money;
            
            int betNumber = rand.Next(0, 37);
            int betAmount = rand.Next(10, Math.Min(51, money + 1));
            int roulette = rand.Next(0, 37);

            if (betNumber == roulette)
            {
                money += betAmount;
            }
            else
            {
                money -= betAmount;
            }

            string result = $"Игрок{playerNumber} {startMoney} {money}";

            lock (locker)
            {
                report.Add(result);
                Console.WriteLine(result);
            }

            Thread.Sleep(100);
        }
    }
}

