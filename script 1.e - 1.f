
clc;
clear;
close all;

%% Análise dos Itens 1e e 1f do Projeto

fprintf('--- Início da Análise Computacional (Itens 1e e 1f) ---\n\n');

%% 1. Definição da Planta e das Especificações

% Planta original G(s)
num_G = 8.56e10;
den_G = [1, 5.1894, 31.64];
G = tf(num_G, den_G);

% Especificações
erro_desejado_percent = 7; % em porcentagem
amplitude_degrau = 1.8;
amplitude_rampa = 1;

%% 2. Cálculo do Ganho K (Item 1e)

fprintf('--- Item 1e: Cálculo do Ganho K ---\n');

% Calcula o Kp necessário para o erro desejado
Kp_req = (100 / erro_desejado_percent) - 1;

% Calcula o ganho estático da planta
dc_gain_G = dcgain(G);

% Calcula o ganho K do controlador
K = Kp_req / dc_gain_G;

fprintf('O ganho estático da planta G(s) é: %.2e\n', dc_gain_G);
fprintf('Para um erro de %.1f%%, a constante Kp necessária é: %.4f\n', erro_desejado_percent, Kp_req);
fprintf('O ganho do controlador K deve ser: %.4e\n\n', K);

%% 3. Cálculo das Constantes e Erros (Item 1f)

fprintf('--- Item 1f: Constantes de Erro e Erro em Regime Permanente ---\n');

% Define a função de malha aberta final com o ganho K
L = K * G;

% Calcula as constantes de erro estático
Kp_final = dcgain(L);
Kv_final = dcgain(tf([1, 0], 1) * L); % Multiplica por 's' para o limite
Ka_final = dcgain(tf([1, 0, 0], 1) * L); % Multiplica por 's^2' para o limite

fprintf('Com K = %.4e, as constantes de erro são:\n', K);
fprintf('Kp = %.4f\n', Kp_final);
fprintf('Kv = %.4f\n', Kv_final);
fprintf('Ka = %.4f\n\n', Ka_final);

% Calcula os erros em regime permanente
Ess_degrau = amplitude_degrau / (1 + Kp_final);
Ess_rampa = amplitude_rampa / Kv_final;

fprintf('O erro em regime permanente para uma entrada degrau de amplitude %.2f é: %.4f\n', amplitude_degrau, Ess_degrau);
fprintf('O erro em regime permanente para uma entrada rampa unitária é: %.4f\n', Ess_rampa);
fprintf('------------------------------------------------------------------\n');
