using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net;
using System.IO;
using System.Net.Http;
using System.Runtime.InteropServices;

namespace pogoda
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        // Срабатывание происходит через кнопку
        private async void button1_Click(object sender, EventArgs e)
        {
            string city;
            city = (string)Convert.ChangeType(comboBox1.SelectedItem, typeof(String)); // считываем ComboBox
            switch (city) // нужен для перевода города на английский
            {
                case "Москва":
                    city = "Moscow"; break;
                case "Санкт-Петербург":
                    city = "Saint Petersburg"; break;
                case "Казань":
                    city = "Kazan"; break;
                case "Лондон":
                    city = "London"; break;
            }

            HttpClient client = new HttpClient(); // создаю httpclient
            // на след. строчке открываю ссылку и получаю данные с неё
            string weather = await client.GetStringAsync("https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=f43c84134921b781b2963155107f4b96");
            
            Weather dataWeather = new Weather(); // создаю переменную класса

            dataWeather.DataSeparation(weather); // закидываю в функцию получившие данные с сайта

            // вывод в TextBox
            textBox1.Text = Convert.ToString(dataWeather.Temp) + "°";
            textBox2.Text = dataWeather.Description;
            textBox3.Text = Convert.ToString(dataWeather.WindSpeed) + " m/s";
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }

    public class Weather
    {
        public double Temp { get; set; } // температура
        public string Description { get; set; } // описание
        public double WindSpeed { get; set; } // скорость ветра

        public void DataSeparation(string weather) // в данной функции я делю получившие данные с помощью Split по "
        {
            string[] str = weather.Split('"');
            TempSeparation(str);
            DescriptionSeparation(str);
            WindSpeedSeparation(str);
        }

        private void TempSeparation(string[] str) // функция для получения температуры
        {
            // здесь я пошел по не самому эффективному способу
            double kel = 273.15; // для перевода из кельвинов в градусы
            for(int i = 0; i < str.Length; i++)
            {
                // если нахожу строку с temp
                if (str[i] == "temp")
                {
                    // получаю само число, при этом делю саму строку, т.к. она получается такой :256.38, , убираю с помощью Substring первый и последний символ, а после с помощью Replace
                    // меняю . на , , т.к. double не принимает точку
                    string tempStr = str[i + 1].Substring(1, str[i + 1].Length - 2).Replace('.', ',');
                    Temp = Convert.ToDouble(tempStr);
                    Temp = Math.Ceiling(Temp - kel); // перевожу из кельвинов в градусы и округляю
                    break;
                }
            }
        }

        private void DescriptionSeparation(string[] str) // концепция у всех функций примерно одиннаковая
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == "description") // если нахожу description, то записываю i + 2 элемент массива
                {
                    Description = str[i + 2];
                    break;
                }
            }
        }

        private void WindSpeedSeparation(string[] str)
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (str[i] == "speed") // тоже самое что и в TempSeparation, только без перевода
                {
                    string speedStr = str[i + 1].Substring(1, str[i + 1].Length - 2).Replace('.', ',');
                    WindSpeed = Convert.ToDouble(speedStr);
                    break;
                }
            }
        }
    }

    // к сожалению, я не успел обработать некоторые возможные ошибки, т.к. времени не особо было много из-за подготовки к экзаменам, но надеюсь основную часть я смог сделать правильно :)
}
