KILLERS = [
    "Slasher",
    "Coolkid",
    "Noli",
    "John Doe",
    "1x1x1x1",
    "Guest 666",
    "Vnosnasratu",
    "Azure",
]

SURVIVORS = [
    "Noob",
    "007n7",
    "Veeronica",
    "Shedletsky",
    "Two Time",
    "Guest 1337",
    "Chance",
    "Jane Doe"
    "Taph",
    "Elliot",
    "Dusekkar",
    "Builderman",
]

class Participant:
    def __init__(self, nickname:str, robloxuser:str, discordid:int) -> None:
        self.nickname = nickname
        self.robloxuser = robloxuser
        self.discordid = discordid
        self.TEMPkilleramt = 0

    def __repr__(self) -> str:
        return f"{self.nickname} - {self.robloxuser} - {self.discordid}"

PARTICIPANTS = [
    Participant("somvan", "somvanhaaaaiiiiii", 730864691223593031),
    Participant("pepsya", "2022mm12", 1220054046640046091),
    Participant("anderkva", "anderkva", 1045795103001825400),
    Participant("unt", "unttaka", 577128685342031892),
    Participant("lengot", "lengotova", 796288372388790292),
    #Participant("avelin", "Lynzqqx", 584019099965980674),
    Participant("yung", "jarik122012", 946397884209823745),
    Participant("spl", "Xx_KaKoSuKxX", 903598078387445770),
]

def stdName(n:str) -> str:
    return n.ljust(8, " ")

class MatchCombo:
    def __init__(self, pixcombo:list[int], combonum:int) -> None:
        self.participants:list[Participant] = []
        self.combonum:int = combonum
        for pix in pixcombo:
            self.participants.append(PARTICIPANTS[pix])
        self.participants.sort(key = lambda p: p.TEMPkilleramt)
        self.participants[0].TEMPkilleramt += 1
        self.pixcombo = []
        for p in self.participants:
            self.pixcombo.append(PARTICIPANTS.index(p))

    def __repr__(self) -> str:
        rs = f"#{self.combonum:02d} | Killer: {stdName(self.participants[0].nickname)} | Survivors:"
        for i in range(1, len(self.participants)):
            rs = rs + f" {stdName(self.participants[i].nickname)} |"
        rs = rs + f" | {repr(self.pixcombo)} |"
        return rs