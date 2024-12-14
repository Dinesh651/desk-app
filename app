import tkinter as tk
from tkinter import ttk

class IRDAutomationApp:
    def __init__(self, root):
        self.root = root
        self.root.title("IRD Automation App")
        self.root.geometry("800x500")

        # Sidebar frame
        sidebar = tk.Frame(root, bg="red", width=200)
        sidebar.pack(side=tk.LEFT, fill=tk.Y)

        # Sidebar menu buttons
        menu_items = ["Home", "Tax Services", "Reports", "Help"]
        for item in menu_items:
            btn = tk.Button(sidebar, text=item, bg="white", fg="black", font=("Arial", 12), bd=0, padx=10, pady=10, anchor="w")
            btn.pack(fill=tk.X, pady=2)

        # Main content frame
        main_frame = tk.Frame(root, bg="white")
        main_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        # Header
        header = tk.Label(main_frame, text="IRD Automation", bg="orange", fg="white", font=("Arial", 20), anchor="center")
        header.pack(fill=tk.X)

        # Dropdown for selecting company
        dropdown_frame = tk.Frame(main_frame, bg="white")
        dropdown_frame.pack(pady=10)

        company_label = tk.Label(dropdown_frame, text="Select Company:", bg="white", font=("Arial", 12))
        company_label.pack(side=tk.LEFT, padx=5)

        self.company_var = tk.StringVar()
        self.company_dropdown = ttk.Combobox(dropdown_frame, textvariable=self.company_var, state="readonly", font=("Arial", 12))
        self.company_dropdown.pack(side=tk.LEFT, padx=5)
        self.load_companies()

        self.company_dropdown.bind("<<ComboboxSelected>>", self.on_company_select)

        # Add Entity button
        add_entity_btn = tk.Button(dropdown_frame, text="Add Entity", bg="green", fg="white", font=("Arial", 12), command=self.open_add_entity_window)
        add_entity_btn.pack(side=tk.LEFT, padx=10)

        # Grid for menu items
        menu_frame = tk.Frame(main_frame, bg="white")
        menu_frame.pack(pady=20, padx=20)

        items = [
            {"name": "Taxpayer Login", "image": "🔑", "command": self.taxpayer_login},
            {"name": "E-TDS", "image": "📄", "command": self.e_tds},
            {"name": "VAT Return", "image": "💼", "command": self.vat_return},
            {"name": "CBMS Portal", "image": "🌐", "command": self.cbms_portal},
        ]

        for i, item in enumerate(items):
            frame = tk.Frame(menu_frame, bg="lightgray", width=100, height=100)
            frame.grid(row=i//2, column=i%2, padx=10, pady=10)
            frame.pack_propagate(False)

            # Item image
            image_label = tk.Label(frame, text=item["image"], font=("Arial", 25), bg="lightgray")
            image_label.pack()

            # Item name
            name_label = tk.Button(frame, text=item["name"], bg="lightgray", font=("Arial", 12), command=item["command"])
            name_label.pack()

        self.selected_company_data = {}

    def load_companies(self):
        try:
            with open("data.txt", "r") as file:
                lines = file.readlines()
                companies = []
                for line in lines:
                    if line.startswith("co = "):
                        companies.append(line.split("= ")[1].strip())
                companies.sort()  # Sort companies alphabetically
                self.company_dropdown["values"] = companies
                if companies:
                    self.company_var.set(companies[0])
        except FileNotFoundError:
            self.company_dropdown["values"] = []

    def on_company_select(self, event):
        selected_company = self.company_var.get()
        self.selected_company_data = {}
        try:
            with open("data.txt", "r") as file:
                lines = file.readlines()
                current_company = None
                for line in lines:
                    if line.startswith("co = "):
                        current_company = line.split("= ")[1].strip()
                    if current_company == selected_company:
                        if line.startswith("usr = "):
                            self.selected_company_data["usr"] = line.split("= ")[1].strip()
                        elif line.startswith("paw = "):
                            self.selected_company_data["paw"] = line.split("= ")[1].strip()
                        elif line.startswith("phn = "):
                            self.selected_company_data["phn"] = line.split("= ")[1].strip()
        except FileNotFoundError:
            pass

        # Store the data in variables or process as needed
        print(f"Selected Company Data: {self.selected_company_data}")

    def open_add_entity_window(self):
        # Create a new top-level window
        add_entity_window = tk.Toplevel(self.root)
        add_entity_window.title("Add Entity")
        add_entity_window.geometry("400x300")

        # Form fields
        fields = ["Company Name", "Company PAN", "Password", "Phone No"]
        entries = {}

        for i, field in enumerate(fields):
            label = tk.Label(add_entity_window, text=field, font=("Arial", 12))
            label.grid(row=i, column=0, padx=10, pady=5, sticky="w")
            entry = tk.Entry(add_entity_window, font=("Arial", 12))
            entry.grid(row=i, column=1, padx=10, pady=5)
            entries[field] = entry

        # Submit button
        def submit_entity():
            with open("data.txt", "a") as file:
                file.write(f"co = {entries['Company Name'].get()}\n")
                file.write(f"usr = {entries['Company PAN'].get()}\n")
                file.write(f"paw = {entries['Password'].get()}\n")
                file.write(f"phn = {entries['Phone No'].get()}\n\n")
            add_entity_window.destroy()
            self.load_companies()

        submit_btn = tk.Button(add_entity_window, text="Submit", bg="green", fg="white", font=("Arial", 12), command=submit_entity)
        submit_btn.grid(row=len(fields), columnspan=2, pady=20)

    def taxpayer_login(self):
        print("Taxpayer Login clicked")
        print(f"usr: {self.selected_company_data.get('usr', 'N/A')}")
        print(f"paw: {self.selected_company_data.get('paw', 'N/A')}")
        print(f"phn: {self.selected_company_data.get('phn', 'N/A')}")

    def e_tds(self):
        print("E-TDS clicked")
        print(f"usr: {self.selected_company_data.get('usr', 'N/A')}")
        print(f"paw: {self.selected_company_data.get('paw', 'N/A')}")
        print(f"phn: {self.selected_company_data.get('phn', 'N/A')}")

    def vat_return(self):
        print("VAT Return clicked")
        print(f"usr: {self.selected_company_data.get('usr', 'N/A')}")
        print(f"paw: {self.selected_company_data.get('paw', 'N/A')}")
        print(f"phn: {self.selected_company_data.get('phn', 'N/A')}")

    def cbms_portal(self):
        print("CBMS Portal clicked")
        print(f"usr: {self.selected_company_data.get('usr', 'N/A')}")
        print(f"paw: {self.selected_company_data.get('paw', 'N/A')}")
        print(f"phn: {self.selected_company_data.get('phn', 'N/A')}")

# Create the root window and run the app
if __name__ == "__main__":
    root = tk.Tk()
    app = IRDAutomationApp(root)
    root.mainloop()
