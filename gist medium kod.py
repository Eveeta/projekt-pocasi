import pandas as pd


def zpracuj_soubor(
    path,
):
    stanice_ID = ""
    prvek = ""
    with open(path) as vzduch:
        cislo_radky = 0
        metadata = 1
        prvek = "Vzduch"
        for line in vzduch.readlines(cislo_radky):
            if line == "DATA\n":
                break
            cislo_radky += 1
            metadata += 1
            if line == "METADATA\n":
                metadata = -2
            if metadata == 0:
                stanice_ID = line.split(";")[0]
    df = pd.read_csv(path, skiprows=cislo_radky + 1, delimiter=";", encoding="cp1250")
    df["stanice_ID"] = stanice_ID
    df["prvek"] = prvek
    if df["Hodnota"].dtype == "O":
        df["Hodnota"] = df["Hodnota"].str.replace(",", ".")
        df["Hodnota"] = pd.to_numeric(df["Hodnota"])
    return df


import glob

path = "C:\\Users\\User\\OneDrive\\Plocha\\data\\Vlhkost vzduchu\\"


def zpracuj_slozku(slozka):
    df_all = pd.DataFrame()
    for jmeno_souboru in glob.glob(slozka + "*.csv"):
        print(jmeno_souboru)
        df = zpracuj_soubor(jmeno_souboru)
        print(df)
        df_all = pd.concat([df_all, df])
    return df_all


df_slozka = zpracuj_slozku("C:\\Users\\User\\OneDrive\\Plocha\\data\\Vlhkost vzduchu\\")
df_slozka.to_csv(
    "C:\\Users\\User\\OneDrive\\Plocha\\data\\Vlhkost vzduchu\\Out\\vlhkost.csv"
)
