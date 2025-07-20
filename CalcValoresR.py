# --- 1. Defina os pontos de operação aqui ---
# Ponto A: (entrada, saida)
v1a, v2a = 100*0.025, 0.3
# Ponto B: (entrada, saida)
v1b, v2b = 0, 3

# --- 2. Valores fixos e cálculos ---
R1 = 10e3
R4 = 100e3

# Resolve para Vm, R2 e R3
Vm = (v2a * v1b - v2b * v1a) / ((v2a - v2b) + (v1b - v1a))
R2 = -R1 * (v2a - Vm) / (v1a - Vm)
R3 = (30 * R4 / (Vm + 15)) - R4

# --- 3. Exibe os resultados ---
print(f"Tensão de Offset Vm = {Vm:.4f} V")
print(f"Resistor R2 = {R2/1e3:.3f} kΩ")
print(f"Resistor R3 = {R3/1e3:.3f} kΩ")