import pandas as pd
import matplotlib.pyplot as plt
import os


def identify(data, idx, window=5):
    before = data[max(0, idx - window):idx].mean()
    after = data[idx:min(len(data), idx + window)].mean()
    current = data[idx]

    if abs(current - before) > abs(after - before):
        return 'Spike'
    elif abs(after - before) > 1.0:
        return 'Level Shift'
    return 'Trend Change'


def CUSUM_Anomaly_Detection(x, threshold, drift):
    g_plus = [0]
    g_minus = [0]
    anomalies = []
    anomaly_types = []

    for t in range(1, len(x)):
        St = x[t] - x[t - 1]
        g_plus_t = max(g_plus[-1] + St - drift, 0)
        g_minus_t = max(g_minus[-1] - St - drift, 0)

        if g_plus_t > threshold or g_minus_t > threshold:
            anomalies.append(t)
            anomaly_types.append(identify(x, t))
            g_plus_t = 0
            g_minus_t = 0

        g_plus.append(g_plus_t)
        g_minus.append(g_minus_t)

    return anomalies, anomaly_types, g_plus, g_minus


os.makedirs('Plots', exist_ok=True)
data = pd.read_excel('Temperatura.xlsx', parse_dates=['Timestamp'])
data.columns = data.columns.str.strip()

threshold = 50
drift = 50
columns = ['DS18B20', 'DHT11', 'LM35DZ', 'BMP180', 'Thermistor', 'DHT22']
colors = {'Spike': 'red', 'Level Shift': 'orange', 'Trend Change': 'purple'}

for column in columns:
    if column in data.columns:
        x = data[column].values
        anomalies, types, g_plus, g_minus = CUSUM_Anomaly_Detection(x, threshold, drift)

        plt.figure(figsize=(10, 6))
        plt.plot(data['Timestamp'], x, label=f'{column} Temperature', color='green')

        for idx, atype in zip(anomalies, types):
            plt.scatter(data['Timestamp'].iloc[idx], x[idx],
                        color=colors[atype], label=f'{atype}', s=100)

        plt.title(f'CUSUM Anomaly Detection for {column}')
        plt.xlabel('Timestamp')
        plt.ylabel('Temperature (°C)')
        handles, labels = plt.gca().get_legend_handles_labels()
        by_label = dict(zip(labels, handles))
        plt.legend(by_label.values(), by_label.keys())
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig(f'Plots/{column}_anomalies.png')
        plt.close()
    else:
        print(f"Column {column} not found in the data.")