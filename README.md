

## **Register File Module**

### **1. Purpose**
The **register_file** module is designed to simulate a set of registers, providing simultaneous read and write capabilities. It is an essential component in processor architectures, used for temporarily storing values during processing.

---

### **2. Key Features**
- **Number of Registers:** 32 registers, each 32 bits wide.
- **Simultaneous Read:** Supports two parallel read ports, controlled by enable signals.
- **Write Capability:** Supports writing data to a specific register, controlled by the `wr_en` signal.
- **Conditional Operation:**
  - Operates only when the `ce` (chip enable) signal is active.
  - Resets all registers to their default values when the `rst_n` (reset) signal is low.

---

### **3. Inputs and Outputs**
#### **Inputs:**
1. **`clk` (Clock):** Synchronization signal that controls module operation.
2. **`rst_n` (Reset - Active Low):** Asynchronous reset signal. When low, all registers are reset to the default value `32'h00000000`.
3. **`ce` (Chip Enable):** Activates the module. If `ce = 0`, read/write ports are disabled.
4. **`rd_en1`, `rd_en2` (Read Enable):** Signals that enable the respective read ports.
5. **`rd_addr1`, `rd_addr2` (Read Address):** Addresses of the registers to be read.
6. **`wr_en` (Write Enable):** Signal that enables writing data to a register.
7. **`wr_addr` (Write Address):** Address of the register to which data is written.
8. **`wr_data` (Write Data):** Data to be written to the specified register.

#### **Outputs:**
1. **`rd_data1`, `rd_data2`:** Data read from the addresses `rd_addr1` and `rd_addr2`.

---

### **4. Module Operation**
#### **Reset (Asynchronous Reset)**
- When `rst_n = 0`, all registers are reset to `32'h00000000`.
- The outputs `rd_data1` and `rd_data2` are also reset to `32'h00000000`.

#### **Read Operation**
- When `ce` and `rd_en1` or `rd_en2` are active, data from addresses `rd_addr1` and `rd_addr2` is output to `rd_data1` and `rd_data2`.
- If `ce` or `rd_en` are not active, the outputs default to `32'h00000000`.

#### **Write Operation**
- When `ce` and `wr_en` are active, the data `wr_data` is written to the register at address `wr_addr`.
- Otherwise, the value in the register at that address remains unchanged.

---

### **5. Structure Description**
#### **Core Structure**
- **Registers:** Implemented as an array `reg [31:0] reg_file[31:0]` to simulate 32 registers, each 32 bits wide.
- **Read Operation:** Performed through two parallel read ports with conditional checks on control signals.
- **Write Operation:** Performed using an `always` block triggered by `clk` or `rst_n`.

#### **Synchronous and Asynchronous Behavior**
- **Reset:** Asynchronous, ensuring the registers reset to their default values as soon as the `rst_n` signal goes low.
- **Read/Write:** Synchronous with the rising edge of the `clk` signal.

---

### **6. Applications**
The **register_file** module is commonly used in digital systems such as:
- **CPU (Central Processing Unit):** Temporarily stores operands or computation results.
- **DSP (Digital Signal Processor):** Processes digital data with fast access requirements.
- **Microcontroller:** Core component for storing data and state in embedded systems.

