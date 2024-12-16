import pandas as pd

data = pd.read_csv('04-12-22_temperature_measurements.csv')

def to_binary(x):
    try:
        return format(int(x), 'b')
    except ValueError:
        return None

for column in data.columns:

    values = data[column].apply(to_binary)

    with open(f'{column}_binary.txt', 'w') as file:
        for value in values:
            if value is not None:
                file.write(value + '\n')

    print(f"Done {column}")
