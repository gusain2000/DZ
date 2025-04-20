using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;

namespace FileDownloaderApp
{
    public partial class MainWindow : Window
    {
        private static Mutex _mutex = new Mutex();
        private static List<string> _fileUrls = new List<string>
        {
            "https://images.hdqwalls.com/download/flash-barry-allen-2022-4k-a2-3840x2160.jpg", // Example file URLs
            "https://images.wallpapersden.com/image/download/marvel-spider-man-hd-art-2022_bWZqbWyUmZqaraWkpJRsa21lrWloZ2U.jpg",
            "https://i.ytimg.com/vi/u6RRZf5q0t0/maxresdefault.jpg"
        };

        public MainWindow()
        {
            InitializeComponent();
        }

        private async void DownloadFilesButton_Click(object sender, RoutedEventArgs e)
        {
            StatusListBox.Items.Clear();
            List<Task> downloadTasks = new List<Task>();

            foreach (var url in _fileUrls)
            {
                downloadTasks.Add(DownloadFileAsync(url));
            }
            await Task.WhenAll(downloadTasks);
            
            StatusListBox.Items.Add("All files have been downloaded!");
        }

        private async Task DownloadFileAsync(string url)
        {
            AddStatus($"Thread started downloading: {url}");
            using (HttpClient client = new HttpClient())
            {
                try
                {
                    var response = await client.GetAsync(url);

                    if (response.IsSuccessStatusCode)
                    {
                        _mutex.WaitOne();
                        try
                        {
                            AddStatus($"Download completed for {url}.");
                        }
                        finally
                        {
                            _mutex.ReleaseMutex();
                        }
                    }
                    else
                    {
                        AddStatus($"Error downloading from {url}");
                    }
                }
                catch (Exception ex)
                {
                    AddStatus($"Error downloading {url}: {ex.Message}");
                }
            }
            
            AddStatus($"Thread finished downloading: {url}");
        }

        private void AddStatus(string message)
        {
            Dispatcher.Invoke(() => StatusListBox.Items.Add(message));
        }
    }
}
