import time
from datetime import datetime


def now():
    return int(time.time()*1000)


def duration_in_days(dt1: datetime.date, dt2: datetime.date):
    return abs((dt1 - dt2).days)


def date_from_timestamp(t: int):
    return datetime.fromtimestamp(t/1000).date()
