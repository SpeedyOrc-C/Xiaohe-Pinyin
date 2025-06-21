local rime = require "sbxlm.lib"
local yield = rime.yield
local Candidate = rime.Candidate

---@param c string
---@return string
local function proper_upper(c)
    c = string.upper(c)
    c = string.gsub(c, "ā", "Ā")
    c = string.gsub(c, "á", "Á")
    c = string.gsub(c, "ǎ", "Ǎ")
    c = string.gsub(c, "à", "À")
    c = string.gsub(c, "ē", "Ē")
    c = string.gsub(c, "é", "É")
    c = string.gsub(c, "ě", "Ě")
    c = string.gsub(c, "è", "È")
    c = string.gsub(c, "ī", "Ī")
    c = string.gsub(c, "í", "Í")
    c = string.gsub(c, "ǐ", "Ǐ")
    c = string.gsub(c, "ì", "Ì")
    c = string.gsub(c, "ō", "Ō")
    c = string.gsub(c, "ó", "Ó")
    c = string.gsub(c, "ǒ", "Ǒ")
    c = string.gsub(c, "ò", "Ò")
    c = string.gsub(c, "ū", "Ū")
    c = string.gsub(c, "ú", "Ú")
    c = string.gsub(c, "ǔ", "Ǔ")
    c = string.gsub(c, "ù", "Ù")
    c = string.gsub(c, "ǖ", "Ǖ")
    c = string.gsub(c, "ǘ", "Ǘ")
    c = string.gsub(c, "ǚ", "Ǚ")
    c = string.gsub(c, "ǜ", "Ǜ")
    c = string.gsub(c, "ê", "Ê")
    c = string.gsub(c, "ế", "Ế")
    c = string.gsub(c, "ề", "Ề")
    return c
end

---@param vowel string
---@param tone number
---@return string
local function add_tone_to_vowel(vowel, tone)
    if vowel == "a" then
        if tone == 1 then return "ā" end
        if tone == 2 then return "á" end
        if tone == 3 then return "ǎ" end
        if tone == 4 then return "à" end
        return "a"
    elseif vowel == "e" then
        if tone == 1 then return "ē" end
        if tone == 2 then return "é" end
        if tone == 3 then return "ě" end
        if tone == 4 then return "è" end
        return "e"
    elseif vowel == "i" then
        if tone == 1 then return "ī" end
        if tone == 2 then return "í" end
        if tone == 3 then return "ǐ" end
        if tone == 4 then return "ì" end
        return "i"
    elseif vowel == "o" then
        if tone == 1 then return "ō" end
        if tone == 2 then return "ó" end
        if tone == 3 then return "ǒ" end
        if tone == 4 then return "ò" end
        return "o"
    elseif vowel == "u" then
        if tone == 1 then return "ū" end
        if tone == 2 then return "ú" end
        if tone == 3 then return "ǔ" end
        if tone == 4 then return "ù" end
        return "u"
    elseif vowel == "ü" then
        if tone == 1 then return "ǖ" end
        if tone == 2 then return "ǘ" end
        if tone == 3 then return "ǚ" end
        if tone == 4 then return "ǜ" end
        return "ü"
    elseif vowel == "ê" then
        if tone == 2 then return "ế" end
        if tone == 4 then return "ề" end
        return "ê"
    else
        return vowel
    end
end

---@param final string
---@param tone number
---@return string
local function add_tone_to_final(final, tone)
    local function f(vowel)
        return add_tone_to_vowel(vowel, tone)
    end

    local mapping = {
        ["a"] = f("a"),
        ["e"] = f("e"),
        ["i"] = f("i"),
        ["o"] = f("o"),
        ["u"] = f("u"),
        ["ü"] = f("ü"),
        ["ê"] = f("ê"),
        ["ai"] = f("a").."i",
        ["ao"] = f("a").."o",
        ["an"] = f("a").."n",
        ["ang"] = f("a").."ng",
        ["ei"] = f("e").."i",
        ["en"] = f("e").."n",
        ["eng"] = f("e").."ng",
        ["er"] = f("e").."r",
        ["ia"] = "i"..f("a"),
        ["iao"] = "i"..f("a").."o",
        ["ian"] = "i"..f("a").."n",
        ["iang"] = "i"..f("a").."ng",
        ["ie"] = "i"..f("e"),
        ["iong"] = "i"..f("o").."ng",
        ["iu"] = "i"..f("u"),
        ["in"] = f("i").."n",
        ["ing"] = f("i").."ng",
        ["ou"] = f("o").."u",
        ["ong"] = f("o").."ng",
        ["ua"] = "u"..f("a"),
        ["uai"] = "u"..f("a").."i",
        ["uan"] = "u"..f("a").."n",
        ["uang"] = "u"..f("a").."ng",
        ["ue"] = "u"..f("e"),
        ["ui"] = "u"..f("i"),
        ["un"] = f("u").."n",
        ["uo"] = "u"..f("o"),
    }

    return mapping[final]
end

local simple_initial_mapping = {
    ["b"] = "b",
    ["p"] = "p",
    ["m"] = "m",
    ["f"] = "f",
    ["d"] = "d",
    ["t"] = "t",
    ["n"] = "n",
    ["l"] = "l",
    ["g"] = "g",
    ["k"] = "k",
    ["h"] = "h",
    ["j"] = "j",
    ["q"] = "q",
    ["x"] = "x",
    ["v"] = "zh",
    ["i"] = "ch",
    ["u"] = "sh",
    ["r"] = "r",
    ["z"] = "z",
    ["c"] = "c",
    ["s"] = "s",
    ["y"] = "y",
    ["w"] = "w",
}

---@param raw_initial string
---@return string | nil
local function expand_initial(raw_initial)
    return simple_initial_mapping[raw_initial]
end

local simple_final_mapping = {
    ["q"] = "iu",
    ["w"] = "ei",
    ["e"] = "e",
    ["r"] = "uan",
    ["t"] = "ue",
    ["y"] = "un",
    ["u"] = "u",
    ["i"] = "i",
    ["p"] = "ie",
    ["a"] = "a",
    ["d"] = "ai",
    ["f"] = "en",
    ["g"] = "eng",
    ["h"] = "ang",
    ["j"] = "an",
    ["z"] = "ou",
    ["c"] = "ao",
    ["b"] = "in",
    ["n"] = "iao",
    ["m"] = "ian",
}

---@param raw_i string
---@param raw_f string
---@return string | nil
local function expand_final(raw_i, raw_f)
    if raw_i == "b" or raw_i == "p" or raw_i == "m" or raw_i == "f" or raw_i == "y" or raw_i == "w" then
        if raw_f == "o" then
            return "o"
        end
    else
        if raw_f == "o" then
            return "uo"
        end
    end

    if raw_i == "j" or raw_i == "q" or raw_i == "x" then
        if raw_f == "s" then
            return "iong"
        elseif raw_f == "x" then
            return "ia"
        end
    else
        if raw_f == "s" then
            return "ong"
        elseif raw_f == "x" then
            return "ua"
        end
    end

    if raw_i == "j" or raw_i == "q" or raw_i == "x" or raw_i == "b" then
        if raw_f == "l" then
            return "iang"
        end
    else
        if raw_f == "l" then
            return "uang"
        end
    end

    if raw_i == "g" or raw_i == "k" or raw_i == "h" or raw_i == "v" or raw_i == "i" or raw_i == "u" then
        if raw_f == "k" then
            return "uai"
        end
    else
        if raw_f == "k" then
            return "ing"
        end
    end

    if raw_i == "n" or raw_i == "l" then
        if raw_f == "v" then
            return "ü"
        end
    else
        if raw_f == "v" then
            return "ui"
        end
    end

    return simple_final_mapping[raw_f]
end


---@param input string
---@return string | nil
local function xiaohe2pinyin(input)
    local tone

    if string.len(input) < 2 then return nil end
    if string.len(input) > 3 then return nil end

    if string.len(input) == 3 then
        local raw_tone = string.sub(input, 3, 3)

        if raw_tone == "1" then tone = 1
        elseif raw_tone == "2" then tone = 2
        elseif raw_tone == "3" then tone = 3
        elseif raw_tone == "4" then tone = 4
        elseif raw_tone == "5" then tone = 5
        else return nil end
    else
        tone = 5
    end

    local raw_syllable = string.sub(input, 1, 2)
    local raw_initial = string.sub(input, 1, 1)
    local raw_final = string.sub(input, 2, 2)

    local initial_is_upper = string.match(raw_initial, "%u")
    local final_is_upper = string.match(raw_final, "%u")

    raw_initial = string.lower(raw_initial)
    raw_final = string.lower(raw_final)
    raw_syllable = string.lower(raw_syllable)

    ---@param s string
    ---@return string
    local function change_case(s)
        if initial_is_upper and final_is_upper then
            return proper_upper(s)
        elseif initial_is_upper then
            return proper_upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
        else
            return s
        end
    end

    local function change_case_add_tone_to_final(s)
        return change_case(add_tone_to_final(s, tone))
    end

    if raw_syllable == "aa" then
        return change_case_add_tone_to_final("a")
    elseif raw_syllable == "ah" then
        return change_case_add_tone_to_final("ang")
    elseif raw_syllable == "an" then
        return change_case_add_tone_to_final("an")
    elseif raw_syllable == "ao" then
        return change_case_add_tone_to_final("ao")
    elseif raw_syllable == "ai" then
        return change_case_add_tone_to_final("ai")
    elseif raw_syllable == "ee" then
        return change_case_add_tone_to_final("e")
    elseif raw_syllable == "oo" then
        return change_case_add_tone_to_final("o")
    elseif raw_syllable == "ou" then
        return change_case_add_tone_to_final("ou")
    end

    local initial = expand_initial(raw_initial)
    if initial == nil then return nil end

    local final = expand_final(raw_initial, raw_final)
    if final == nil then return nil end

    return change_case(initial .. add_tone_to_final(final, tone))
end

local function xiaohe2pinyin_translator(input, seg, env)
    local result = xiaohe2pinyin(input)

    if result == nil then return end

    yield(Candidate("", seg.start, seg._end, result, ""))
end

return xiaohe2pinyin_translator
