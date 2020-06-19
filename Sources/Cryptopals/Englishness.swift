import Foundation


/*
This class determines how 'likely' a string is to be English, based on
character frequency. Returns a value between 0 and 1, where 0 means
'totally unlike English', and 1 means 'exactly like English'.

Implementation wise, this calculates the 'Bhattacharyya Coefficient'.
This is a fairly intuitive measure of overlap of two different distributions:
for each point in the distribution, multiply the probability for each distribution
together, then take the square root. Sum all the probabilities together,
and you get your coefficient.

https://github.com/Lukasa/cryptopals/blob/master/cryptopals/challenge_one/three.py
*/

struct Englishness {
    
    // This is an approximate character frequency table of the English language.
    // We'll use it to determine which plaintext is closest to being English. The
    // table maps character to frequency, a number between 0 and 1. Note that this
    // table implicitly assumes an ASCII representation of the english language.
    static let FREQUENCY_TABLE: [String: Double] = [
        " ":  0.12705,
        "a":  0.08167,
        "b":  0.01492,
        "c":  0.02782,
        "d":  0.04253,
        "e":  0.12702,
        "f":  0.02228,
        "g":  0.02015,
        "h":  0.06094,
        "i":  0.06966,
        "j":  0.00153,
        "k":  0.00772,
        "l":  0.04025,
        "m":  0.02406,
        "n":  0.06749,
        "o":  0.07507,
        "p":  0.01929,
        "q":  0.00095,
        "r":  0.05987,
        "s":  0.06327,
        "t":  0.09056,
        "u":  0.02758,
        "v":  0.00978,
        "w":  0.02360,
        "x":  0.00150,
        "y":  0.01974,
        "z":  0.00074
    ]
    
    static func score(input: String) -> Double {
        /*
         First calculate the character frequency
         */
        var inputLetterFreq: [String: Double] = [:]
        for letter in input {
            inputLetterFreq[letter.lowercased(), default: 0.0] += 1.0
        }
        
        /*
         We then want to sum the square roots of the products of the probability
         from both the inputLetterFreq and the English frequency table. If an
         element is entirely absent then the frequency is zero: this penalises
         punctuation heavily.
         */
        let totalCharacters = Double(input.count)
        var coefficient : Double = 0.0
        for (letter, freq) in inputLetterFreq {
            coefficient += sqrt(FREQUENCY_TABLE[letter, default: 0.0] * freq/totalCharacters)
        }
        
        return coefficient
    }
}
