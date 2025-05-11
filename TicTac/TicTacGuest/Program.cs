using System;
using System.IO;
using System.Net.Sockets;

class Program
{
    static char[,] board = new char[3, 3];

    static void Main()
    {
        InitBoard();

        Console.Write("Введите IP сервера: ");
        string ip = Console.ReadLine();

        TcpClient client = new TcpClient(ip, 5000);
        Console.WriteLine("Подключено к серверу.");

        NetworkStream stream = client.GetStream();
        StreamReader reader = new StreamReader(stream);
        StreamWriter writer = new StreamWriter(stream) { AutoFlush = true };

        char mySymbol = reader.ReadLine()[0];
        char enemySymbol = mySymbol == 'X' ? 'O' : 'X';

        Console.WriteLine($"Вы играете за: {mySymbol}");

        while (true)
        {
            string msg = reader.ReadLine();
            var parts = msg.Split(',');
            int ex = int.Parse(parts[0]);
            int ey = int.Parse(parts[1]);
            board[ey, ex] = enemySymbol;

            if (CheckWin(enemySymbol)) { DrawBoardWithCursor(-1, -1, enemySymbol); Console.WriteLine("Вы проиграли!"); break; }
            if (IsDraw()) { DrawBoardWithCursor(-1, -1, enemySymbol); Console.WriteLine("Ничья!"); break; }

            var (x, y) = PlayerMove(mySymbol);
            board[y, x] = mySymbol;
            writer.WriteLine($"{x},{y}");

            if (CheckWin(mySymbol)) { DrawBoardWithCursor(-1, -1, mySymbol); Console.WriteLine("Вы победили!"); break; }
            if (IsDraw()) { DrawBoardWithCursor(-1, -1, mySymbol); Console.WriteLine("Ничья!"); break; }
        }

        client.Close();
    }

    static void InitBoard()
    {
        for (int y = 0; y < 3; y++)
            for (int x = 0; x < 3; x++)
                board[y, x] = ' ';
    }

    static (int x, int y) PlayerMove(char symbol)
    {
        int x = 0, y = 0;
        while (true)
        {
            DrawBoardWithCursor(x, y, symbol);
            var key = Console.ReadKey(true);
            switch (key.Key)
            {
                case ConsoleKey.LeftArrow: if (x > 0) x--; break;
                case ConsoleKey.RightArrow: if (x < 2) x++; break;
                case ConsoleKey.UpArrow: if (y > 0) y--; break;
                case ConsoleKey.DownArrow: if (y < 2) y++; break;
                case ConsoleKey.Enter:
                    if (board[y, x] == ' ') return (x, y);
                    Console.Beep(); break;
            }
        }
    }

    static void DrawBoardWithCursor(int cx, int cy, char symbol)
    {
        Console.Clear();
        Console.WriteLine("Вы играете за: " + symbol);
        Console.WriteLine("  0 1 2");
        for (int y = 0; y < 3; y++)
        {
            Console.Write(y + " ");
            for (int x = 0; x < 3; x++)
            {
                if (x == cx && y == cy)
                {
                    Console.BackgroundColor = ConsoleColor.White;
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.Write(board[y, x] == ' ' ? symbol : board[y, x]);
                    Console.ResetColor();
                }
                else
                {
                    Console.Write(board[y, x]);
                }
                if (x < 2) Console.Write("|");
            }
            if (y < 2) Console.WriteLine("\n  -----");
            else Console.WriteLine();
        }
    }

    static bool CheckWin(char p)
    {
        for (int i = 0; i < 3; i++)
            if ((board[i, 0] == p && board[i, 1] == p && board[i, 2] == p) ||
                (board[0, i] == p && board[1, i] == p && board[2, i] == p))
                return true;
        return (board[0, 0] == p && board[1, 1] == p && board[2, 2] == p) ||
               (board[0, 2] == p && board[1, 1] == p && board[2, 0] == p);
    }

    static bool IsDraw()
    {
        foreach (char c in board)
            if (c == ' ') return false;
        return true;
    }
}
