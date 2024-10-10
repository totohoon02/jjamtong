from datetime import date, timedelta
from enum import Enum


class DATE_TYPE(Enum):
    START = 0
    END = 1


class DateUtil:
    def __init__(self) -> None:
        self.RESTART_TERM = 8
        self.DURATION = 21
        self.pinned_date = {
            "date": date(2024, 12, 10),
            "type": DATE_TYPE.END
        }

    @staticmethod
    def date_after(after=0, start_day=date.today().day, start_month=date.today().month, start_year=date.today().year):
        start_date = date(start_year, start_month, start_day)

        return start_date + timedelta(after)

    def next(self):
        if self.pinned_date['type'] == DATE_TYPE.START:
            self.pinned_date['date'] += timedelta(self.DURATION)
            self.pinned_date['type'] = DATE_TYPE.END
        else:
            self.pinned_date['date'] += timedelta(self.RESTART_TERM)
            self.pinned_date['type'] = DATE_TYPE.START
        return self

    def prev(self):
        if self.pinned_date['type'] == DATE_TYPE.START:
            self.pinned_date['date'] -= timedelta(self.DURATION)
            self.pinned_date['type'] = DATE_TYPE.END
        else:
            self.pinned_date['date'] -= timedelta(self.RESTART_TERM)
            self.pinned_date['type'] = DATE_TYPE.START
        return self

    def get(self, is_print=True):
        if is_print:
            prefix = "까지" if self.pinned_date['type'] == DATE_TYPE.END else "부터"
            print(f"{self.pinned_date['date']} {prefix}")
        return self
