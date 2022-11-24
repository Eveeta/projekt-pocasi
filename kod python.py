import pandas

data = pandas.read_csv("srazky_normal.csv", encoding="cp1250")

data["datum"] = (
    data["Den"].astype(str)
    + "."
    + data["Mesic"].astype(str)
    + "."
    + data["Rok"].astype(str)
)

data["datum"] = pandas.to_datetime(data["datum"], format="%d.%m.%Y")

data.to_csv("datum.csv")
