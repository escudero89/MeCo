function [u] = euler(K, C, f, dt, u_anterior, flag_euler)

    if (flag_euler) % backward
        KC = K + 1/dt * C;
        u = KC \ ( f + 1/dt * C * u_anterior);
    else %forward
        C_inv = inv(C);
        u = C_inv * f * dt + (eye(size(K)) - dt * C_inv * K) * u_anterior;
    end
end