-- LuaSnip JUCE Snippets
-- Dynamic snippets for JUCE audio framework

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function filename()
    return vim.fn.expand('%:t:r')
end

local function plugin_name()
    local name = filename()
    return name:gsub("AudioProcessor$", ""):gsub("AudioProcessorEditor$", "")
end

return {
    -- JUCE AudioProcessor with auto class name
    s({ trig = "juce_processor", name = "JUCE Processor", dscr = "AudioProcessor class generator", priority = 1000 },
        fmt([[
        class {}AudioProcessor : public juce::AudioProcessor
        {{
        public:
            {}AudioProcessor();
            ~{}AudioProcessor() override;

            void prepareToPlay(double sampleRate, int samplesPerBlock) override;
            void releaseResources() override;

            bool isBusesLayoutSupported(const BusesLayout& layouts) const override;
            void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

            juce::AudioProcessorEditor* createEditor() override;
            bool hasEditor() const override;

            const juce::String getName() const override {{ return JucePlugin_Name; }}

            bool acceptsMidi() const override {{ return false; }}
            bool producesMidi() const override {{ return false; }}
            bool isMidiEffect() const override {{ return false; }}
            double getTailLengthSeconds() const override {{ return 0.0; }}

            int getNumPrograms() override {{ return 1; }}
            int getCurrentProgram() override {{ return 0; }}
            void setCurrentProgram(int) override {{}}
            const juce::String getProgramName(int) override {{ return {{}}; }}
            void changeProgramName(int, const juce::String&) override {{}}

            void getStateInformation(juce::MemoryBlock& destData) override;
            void setStateInformation(const void* data, int sizeInBytes) override;

        private:
            {}
            JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR({}AudioProcessor)
        }};
    ]], {
            f(plugin_name, {}),
            rep(1), rep(1),
            i(0, "// Private members"),
            rep(1)
        })),

    -- JUCE processBlock with optimizations
    s(
    { trig = "juce_processblock", name = "Process Block", dscr = "Standard processBlock implementation", priority = 900 },
        fmt([[
        void {}AudioProcessor::processBlock(juce::AudioBuffer<float>& buffer,
                                                          juce::MidiBuffer& midiMessages)
        {{
            juce::ScopedNoDenormals noDenormals;
            auto totalNumInputChannels = getTotalNumInputChannels();
            auto totalNumOutputChannels = getTotalNumOutputChannels();

            // Clear unused outputs
            for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
                buffer.clear(i, 0, buffer.getNumSamples());

            // Process audio
            for (int channel = 0; channel < totalNumInputChannels; ++channel)
            {{
                auto* channelData = buffer.getWritePointer(channel);
                for (int sample = 0; sample < buffer.getNumSamples(); ++sample)
                {{
                    {}
                }}
            }}
        }}
    ]], {
            f(plugin_name, {}),
            i(0, "// Process sample")
        })),

    -- JUCE APVTS with parameter
    s({ trig = "juce_apvts", name = "APVTS Params", dscr = "AudioProcessorValueTreeState Setup" }, fmt([[
        juce::AudioProcessorValueTreeState apvts {{
            *this, nullptr, "Parameters",
            {{
                {}
            }}
        }};
    ]], {
        i(0, 'std::make_unique<juce::AudioParameterFloat>("gain", "Gain", 0.0f, 1.0f, 0.5f)')
    })),

    -- JUCE Slider with attachment
    s({ trig = "juce_slider", name = "Slider Attach", dscr = "Slider with APVTS attachment" }, fmt([[
        juce::Slider {}Slider;
        std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> {}Attachment;

        // In constructor:
        {}Slider.setSliderStyle(juce::Slider::{});
        addAndMakeVisible({}Slider);

        {}Attachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(
            audioProcessor.apvts, "{}", {}Slider);
    ]], {
        i(1, "gain"),
        rep(1),
        rep(1),
        c(2, { t("LinearVertical"), t("LinearHorizontal"), t("Rotary") }),
        rep(1),
        rep(1),
        i(3, "paramId"),
        rep(1)
    })),

    -- JUCE Component with paint and resized
    s({ trig = "juce_component", name = "Component", dscr = "Custom Component skeleton", priority = 900 }, fmt([[
        class {} : public juce::Component
        {{
        public:
            {}() = default;
            ~{}() override = default;

            void paint(juce::Graphics& g) override
            {{
                {}
            }}

            void resized() override
            {{
                {}
            }}

        private:
            {}
            JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR({})
        }};
    ]], {
        i(1, "CustomComponent"),
        rep(1), rep(1),
        i(2, "g.fillAll(juce::Colours::black);"),
        i(3, "// Layout components"),
        i(0, "// Private members"),
        rep(1)
    })),

    -- JUCE Timer
    s({ trig = "juce_timer", name = "Timer Component", dscr = "Component with TimerMixin" }, fmt([[
        class {} : public juce::Component, public juce::Timer
        {{
        public:
            {}() {{ startTimerHz({}); }}
            ~{}() override {{ stopTimer(); }}

            void timerCallback() override
            {{
                {}
                repaint();
            }}

        private:
            JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR({})
        }};
    ]], {
        i(1, "ComponentName"),
        rep(1),
        i(2, "30"),
        rep(1),
        i(0, "// Update logic"),
        rep(1)
    })),
}
