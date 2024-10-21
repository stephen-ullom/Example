//
//  Helpers.swift
//  Example
//
//  Created by Stephen Ullom on 9/15/23.
//

func closestToTarget(_ numbers: [Double], target: Double) -> Double {
  var closestNumber: Double = numbers[0]
  var closestDifference: Double = abs(numbers[0] - target)

  for number in numbers {
    let difference = abs(number - target)
    if difference < closestDifference {
      closestNumber = number
      closestDifference = difference
    }
  }

  return closestNumber
}
