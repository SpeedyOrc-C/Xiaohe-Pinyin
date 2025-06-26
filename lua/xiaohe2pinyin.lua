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
    c = string.gsub(c, "ü", "Ü")
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

    if final == "a" then return f("a")
    elseif final == "e" then return f("e")
    elseif final == "i" then return f("i")
    elseif final == "o" then return f("o")
    elseif final == "u" then return f("u")
    elseif final == "ü" then return f("ü")
    elseif final == "ê" then return f("ê")
    elseif final == "ai" then return f("a").."i"
    elseif final == "ao" then return f("a").."o"
    elseif final == "an" then return f("a").."n"
    elseif final == "ang" then return f("a").."ng"
    elseif final == "ei" then return f("e").."i"
    elseif final == "en" then return f("e").."n"
    elseif final == "eng" then return f("e").."ng"
    elseif final == "er" then return f("e").."r"
    elseif final == "ia" then return "i"..f("a")
    elseif final == "iao" then return "i"..f("a").."o"
    elseif final == "ian" then return "i"..f("a").."n"
    elseif final == "iang" then return "i"..f("a").."ng"
    elseif final == "ie" then return "i"..f("e")
    elseif final == "iong" then return "i"..f("o").."ng"
    elseif final == "iu" then return "i"..f("u")
    elseif final == "in" then return f("i").."n"
    elseif final == "ing" then return f("i").."ng"
    elseif final == "ou" then return f("o").."u"
    elseif final == "ong" then return f("o").."ng"
    elseif final == "ua" then return "u"..f("a")
    elseif final == "uai" then return "u"..f("a").."i"
    elseif final == "uan" then return "u"..f("a").."n"
    elseif final == "uang" then return "u"..f("a").."ng"
    elseif final == "ue" then return "u"..f("e")
    elseif final == "ui" then return "u"..f("i")
    elseif final == "un" then return f("u").."n"
    elseif final == "uo" then return "u"..f("o")
    else error("This should not happen.")
    end
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
local function translate_single_letter(input)
    local len = string.len(input)

    if len < 1 or 2 < len then
        return nil
    end

    local c1 = string.sub(input, 1, 1)

    local tone

    if len == 2 then
        local c2 = string.sub(input, 2, 2)
        if c2 == "1" then tone = 1
        elseif c2 == "2" then tone = 2
        elseif c2 == "3" then tone = 3
        elseif c2 == "4" then tone = 4
        elseif c2 == "5" then tone = 5
        else return nil
        end
    else
        tone = 5
    end

    local is_upper = string.match(c1, "%u")

    c1 = string.lower(c1)

    local function change_case_add_tone_to_final(s)
        if is_upper then
            return proper_upper(add_tone_to_final(s, tone))
        else
            return add_tone_to_final(s, tone)
        end
    end

    if c1 == "a" then
        return change_case_add_tone_to_final("a")
    elseif c1 == "e" then
        return change_case_add_tone_to_final("e")
    elseif c1 == "i" then
        return change_case_add_tone_to_final("i")
    elseif c1 == "o" then
        return change_case_add_tone_to_final("o")
    elseif c1 == "u" then
        return change_case_add_tone_to_final("u")
    elseif c1 == "v" then
        return change_case_add_tone_to_final("ü")
    elseif c1 == "w" and (tone ~= 1 or tone ~= 3) then
        return change_case_add_tone_to_final("ê")
    else
        return nil
    end
end

---@param input string
---@return string | nil
local function xiaohe2pinyin(input)
    local single_letter_result = translate_single_letter(input)

    if single_letter_result ~= nil then
        return single_letter_result
    end

    local tone

    local len = string.len(input)

    if len < 2 then return nil end
    if len > 4 then return nil end

    local rhotic = false

    if len >= 3 then
        local c3 = string.sub(input, 3, 3)
        if c3 == "R" or c3 == "r" then
            rhotic = true
            if len >= 4 then
                local c4 = string.sub(input, 4, 4)
                if c4 == "1" then tone = 1
                elseif c4 == "2" then tone = 2
                elseif c4 == "3" then tone = 3
                elseif c4 == "4" then tone = 4
                elseif c4 == "5" then tone = 5
                else return nil
                end
            else
                tone = 5
            end
        elseif c3 == "1" then tone = 1
        elseif c3 == "2" then tone = 2
        elseif c3 == "3" then tone = 3
        elseif c3 == "4" then tone = 4
        elseif c3 == "5" then tone = 5
        else return nil
        end
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

    if raw_syllable == "ah" then
        return change_case_add_tone_to_final("ang")
    elseif raw_syllable == "an" then
        return change_case_add_tone_to_final("an")
    elseif raw_syllable == "ao" then
        return change_case_add_tone_to_final("ao")
    elseif raw_syllable == "ai" then
        return change_case_add_tone_to_final("ai")
    elseif raw_syllable == "er" then
        return change_case_add_tone_to_final("er")
    elseif raw_syllable == "ou" then
        return change_case_add_tone_to_final("ou")
    end

    local initial = expand_initial(raw_initial)
    if initial == nil then return nil end

    local final = expand_final(raw_initial, raw_final)
    if final == nil then return nil end

    local lower_result = initial .. add_tone_to_final(final, tone)

    if rhotic then
        lower_result = lower_result .. "r"
    end

    local result = change_case(lower_result)

    return result
end

local function xiaohe2pinyin_translator(input, seg, env)
    local result = xiaohe2pinyin(input)

    if result == nil then return end

    yield(Candidate("", seg.start, seg._end, result, ""))
end

return xiaohe2pinyin_translator
