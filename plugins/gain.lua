local plugin = {}

plugin.name = "Gain"
-- todo: add other plugin metadata. like author, description, etc

function plugin.startup()
    return {
        gain = 0.0; -- in dB.
        linear = 1.0;
    }
end

function plugin.process(state, buffer)
    for i = 1, #buffer do
        buffer[i] = buffer[i] * state.linear
    end
end

function plugin.draw(rect, state)
    ui.drawKnob(10, 10, state.gain)
    state.linear = daw.dBtoLinear(state.gain)
end

return plugin