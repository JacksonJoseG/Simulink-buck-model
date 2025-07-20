%% Parâmetros do Conversor DC-DC (Valores Atualizados)
% Este script define os parâmetros para o modelo do Simulink.

clear; clc; close all;

% --- Parâmetros do Circuito ---
L = 2e-3;     % Indutância (H), de 2 mH
C = 10e-6;    % Capacitância (F), de 10 µF
R = 25;       % Resistor de Carga (Ohms)

% --- Parâmetros de Tensão e Chaveamento ---
Vi = 46;      % Tensão de Entrada (V)
Ts = 60e-6;   % Período de Chaveamento (s), de 60 µs

disp('Parâmetros do modelo atualizados e carregados no workspace.');

%% ANÁLISE DOS RESULTADOS DA SIMULAÇÃO COM STEPINFO

tempo_vo = out.Vo_out.Time;
sinal_vo = out.Vo_out.Data;

caracteristicas_vo = stepinfo(sinal_vo, tempo_vo, 'SettlingTimeThreshold', 0.02, 'RiseTimeLimits', [0 1]);

% Exibe os resultados
fprintf('Tempo de Subida (0-100%%): %.3f ms\n', caracteristicas_vo.RiseTime * 1000);
fprintf('Tempo de Acomodação (2%%):  %.3f ms\n', caracteristicas_vo.SettlingTime * 1000);
fprintf('Sobressinal Percentual:   %.2f %%\n', caracteristicas_vo.Overshoot);
fprintf('Valor de Pico:            %.3f V\n\n', caracteristicas_vo.Peak);


% --- Análise da Corrente no Indutor (iL) ---

tempo_il = out.iL_out.Time;
sinal_il = out.iL_out.Data;

% Calcula as características para a corrente
caracteristicas_il = stepinfo(sinal_il, tempo_il, 'SettlingTimeThreshold', 0.02, 'RiseTimeLimits', [0 1]);

% Exibe os resultados
fprintf('Tempo de Subida (0-100%%): %.3f ms\n', caracteristicas_il.RiseTime * 1000);
fprintf('Tempo de Acomodação (2%%):  %.3f ms\n', caracteristicas_il.SettlingTime * 1000);
fprintf('Sobressinal Percentual:   %.2f %%\n', caracteristicas_il.Overshoot);
fprintf('Valor de Pico:            %.3f A\n\n', caracteristicas_il.Peak);

%%
num_Gv_s = [Vi/(L*C)];
den_Gv_s = [1 1/(R*C) 1/(L*C)];
Gv_s = tf(num_Gv_s, den_Gv_s)

Gv_z = c2d(Gv_s, Ts, 'zoh')
%rltool(Gv_z)

num_Gi_s = [Vi*C Vi/R];
den_Gi_s = [L*C L/R 1];
Gi_s = tf(num_Gi_s, den_Gi_s)

Gi_z = c2d(Gi_s, Ts, 'zoh')
%rltool(Gv_z)

%% variáveis de medição

% LV 25-P
% para uma tensão max. de 100 V (prevendo eventual overshoot)
% corrente max. no primario, deve ser 10 mA, portanto:
R_in = 100 / (0.01)

% Vtac_max = 9V
% RangeIn (ADC) = 0.5 - 4.5 V

% Aproximação comercial
R1 = 10e3
R2 = 10800
R3 = 82000
R4 = 100e3

%% Controle contínuo

num_Gv_s = [Vi/(L*C)];
den_Gv_s = [1 1/(R*C) 1/(L*C)];
Gv_s = tf(num_Gv_s, den_Gv_s)

rltool(Gv_s)
