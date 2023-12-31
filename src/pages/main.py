import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
# import requests
from pyodide.http import pyfetch
from pyscript import document, display

def clear_divs():
    date = document.querySelector("#selected-date")
    date.innerText = ""
    wrapper = document.querySelector("#chart-wrapper")
    divs = wrapper.querySelectorAll("div")
    for div in divs:
        div.innerHTML = ""

def into_output(id, content):
    output_div = document.querySelector(f"#{id}")
    output_div.innerText = content

async def fetch_daily_data(event):
    clear_divs()
    input_text = document.querySelector("#date")
    date = input_text.value

    if not date:
        return
    
    data = await request_data(date)

    if len(data) == 0:
        return

    into_output("selected-date", date)
    make_plots(data)

def make_plots(data):
    df = pd.DataFrame(data)
    df['date_time'] = pd.to_datetime(df['date_time'])
    for col in df:
        if col == 'date_time':
            continue
        df[col] = pd.to_numeric(df[col])
    df['time'] = df['date_time'].dt.time
    df = df.drop('cloudbase_low', axis=1)

    col_1 = "Tid (CET)"
    col_2 = "Temperatur"
    col_3 = "Vindstyrka"
    col_4 = "Vindbyar"
    col_5 = "Vindriktning"
    col_6 = "Lufttryck"
    col_7 = "Luftfuktighet"
    
    # Change name for columns
    df = df.rename(columns={
        "date_time": col_1,
        "temp": col_2,
        "wind_speed_ms": col_3,
        "wind_gust_ms": col_4,
        "wind_direction_deg": col_5,
        "pressure_hpa": col_6,
        "humidity": col_7
    })

    plot(df, col_6, col_1, "pressure_hpa")
    plot(df, col_2, col_1, "temp")
    plot(df, col_7, col_1, "humidity")
    plot(df, col_5, col_1, "wind_dir")
    wind_plot(df, col_3, col_4, col_1, "wind")

def plot(df, for_y, for_x, id):
    fig, ax = plt.subplots()
    y = df[for_y]
    x = df[for_x]
    ax.plot(x, y)
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M'))
    ax.set(xlabel=for_x, ylabel=for_y, title=for_y)

    display(fig, target=id)
    plt.close(fig)

def wind_plot(df, wind, gusts, for_x, id):
    fig, ax = plt.subplots()
    y = df[wind]
    y_gusts = df[gusts]
    x = df[for_x]
    ax.plot(x, y)
    ax.plot(x, y_gusts)
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%H:%M'))
    ax.set(xlabel=for_x, ylabel=f"{wind} & {gusts}", title="Vind")
    plt.legend([wind, gusts])

    display(fig, target=id)
    plt.close(fig)

async def request_data(date):
    # Inhämtning och sortering/filtrering av data
    api_url = f"https://w-test.lenticode.com/v1/day?day={date}"

    r = await pyfetch(api_url, timeout=5)
    data = await r.json()

    return data

# def dev_test():
#     date = '2022-06-19'
#     data = request_data_dev(date)
#     make_plots(data)

# def request_data_dev(date):
#     # Inhämtning och sortering/filtrering av data
#     api_url = f"https://w-test.lenticode.com/v1/day?day={date}"

#     r = requests.get(api_url, timeout=5)
#     data = r.json()

#     return data

# dev_test()