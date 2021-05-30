from atsconan import ATSConan

class ATSConan(ATSConan):
    name = "ats-shared-vt"
    version = "0.1"

    def package_info(self):
        super().package_info()
        self.cpp_info.libs = ["ats-shared-vt"]
