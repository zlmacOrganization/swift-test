//
//  Algorithm.swift
//  SwiftTest
//
//  Created by ZhangLiang on 2020/2/19.
//  Copyright © 2020 ZhangLiang. All rights reserved.
//

import Foundation

class BubbleSort {//冒泡排序
    func bubbleSort(_ nums: inout [Int]) {
        let count = nums.count
        for i in 0..<count {
            for j in 0..<count - 1 - i {
                if nums[j] > nums[j + 1] {
                    nums.swapAt(j, j + 1)
                }
            }
        }
    }
}

class InsertSort {//插入排序
    func insertSort(_ nums: [Int]) -> [Int] {
        var nums = nums
        let count = nums.count
        
        if nums.isEmpty || count < 2 {
            return nums
        }
        
        for i in 1..<count {
            let temp = nums[i]
            var k = i
            
            while k > 0 && temp < nums[k - 1] {
                nums[k] = nums[k - 1]
                k -= 1
            }
            
            nums[k] = temp
        }
        
        return nums
    }
}

class SelectSort {//选择排序
    /*
     从数据中选出最大或最小的元素，放在序列的起始位置
     再从剩余的数据中选出，放到已排序数列的末尾
     以此类推，直到全部待排序数据元素为0
     */
    func selectSort(_ nums: inout [Int]) {
        let count = nums.count
        for i in 0..<count - 1 {
            var minIndex = i
            for j in i + 1..<count {
                if nums[i] > nums[j] {
                    minIndex = j
                }
            }
            
            let temp = nums[i]
            nums[i] = nums[minIndex]
            nums[minIndex] = temp
        }
    }
}

class MergeSort {//归并排序
    //从下往上：将待排序的数列分成若干个长度为1的子数列，然后将这些数列两两合并，得到若干个长度为2的子数列，再两两合并，直到合并成一个数列为止
    
    //从上往下：将当前区间一分为二，递归的对两个子区间进行排序，将两个子区间合并为一个有序的区间
    
    func mergeSort(_ arr: [Int]) -> [Int] {
        var arr = arr
        return sort(&arr, low: 0, high: arr.count - 1)
    }

    func sort(_ arr: inout [Int], low: Int, high: Int) -> [Int] {
        var result = arr
        if low < high {
            let mid: Int = (low + high)/2
            _ = sort(&arr, low: low, high: mid)
            _ = sort(&arr, low: mid + 1, high: high)
            result = mergeArray(&arr, low: low, mid: mid, high: high)
        }
        
        return result
    }

    func mergeArray(_ arr: inout [Int], low: Int, mid: Int, high: Int) -> [Int] {
        var i = low
        var j = mid + 1
        var k = 0
        var temp = [Int](repeating: 0, count: arr.count)
        
        while i <= mid && j <= high {
            if arr[i] < arr[j] {
                temp[k] = arr[i]
                i += 1
                k += 1
            }else {
                temp[k] = arr[j]
                j += 1
                k += 1
            }
        }
        
        while i <= mid {
            temp[k] = arr[i]
            i += 1
            k += 1
        }
        
        while j <= high {
            temp[k] = arr[j]
            j += 1
            k += 1
        }
        
        k = 0
        var left = low
        
        while left <= high {
            arr[left] = temp[k]
            left += 1
            k += 1
        }
        
        return arr
    }
}

class QuickSort {//快速排序
    /*
     设定一个分界值，将数组分成左右两部分，
     大于或等于分界值的放在右边，小于的放在左边
     左边和右边同样设分界值，进行处理
     */
    func quickSort(a: inout [Int], low: Int, high: Int) {
        if low >= high { // 递归结束条件
            return
        }
        var i = low
        var j = high
        let key = a[i]
        print("key: \(key)")
        while i < j {
            // 从右边开始比较，比key大的数位置不变
            while i < j && a[j] >= key {
                j -= 1
            }
            // 只要出现一个比key小的数，将这个数放入左边i的位置
            a[i] = a[j]
            print("a[i] = \(a[i]), i = \(i), key = \(key), j = \(j)")
            // 从左边开始比较，比key小的数位置不变
            while i < j && a[i] <= key {
                i += 1
            }
            // 只要出现一个比key大的数，将这个数放入右边j的位置
            a[j] = a[i]
        }
        a[i] = key // 将key放入i的位置，则左侧数都比key小，右侧数都比key大
        quickSort(a: &a, low: low, high: i - 1) // 左递归
        quickSort(a: &a, low: i + 1, high: high) // 右递归
    }
}

class RadixSort {//基数排序
    //将整数按位数切割成不同的数字，然后按每个位数分别比较
    func radixSort(_ unsorts: inout [Int]) {
        let count = unsorts.count
        let d: Double = pow(10.0, Double(String(unsorts.max()!).count))
        
        var k = 1
        var t: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: count), count: 10)
        var num: [Int] = [Int](repeating: 0, count: count)
        
        while Double(k) < d {
            for a in unsorts {
                let m: Int = (a / k)%10
    //            print("m: \(m)")
                t[m][num[m]] = a
                num[m] += 1
            }
    //        print("t: \(t)")
            print("num: \(num)")
            var c = 0
            for i in 0..<count {
                if num[i] != 0 {
                    for j in 0..<num[i] {
                        unsorts[c] = t[i][j]
                        c += 1
                    }
                }
                num[i] = 0
            }
            print("k: \(k)")
            k = k*10
        }
    }

    func radixSort2(_ array: inout [Int]) {
        let radix = 10
        var done = false
        var digit = 1
        var index = 0
        
        while !done {
            done = true
            var buckets: [[Int]] = [[Int]]()
            
            for _ in 1...radix {
                buckets.append([])
            }
            
            for num in array {
                index = num / digit
                print("index: \(index)")
                buckets[index%radix].append(num)
                
                if done && index > 0 {
                    done = false
                }
            }
            
    //        print("buckets: \(buckets)")
            
            var i = 0
            
            for j in 0..<radix {
                let bucket = buckets[j]
                
                for num in bucket {
                    array[i] = num
                    i += 1
                }
            }
            
            digit = digit*radix
        }
        
        print("arr: \(array)")
    }
}

class HeapSort {//堆排序
    
    func heapSort(arr: [Int]) -> [Int] {
        var list = arr
        var endIndex = arr.count - 1
        heapCreate(arr: &list)
        
        while endIndex >= 0 {
            //大顶堆的顶点与大顶堆最后一个值交换
            let temp = list[0]
            list[0] = list[endIndex]
            list[endIndex] = temp
            
            endIndex -= 1
            
            //堆交换之后的大顶堆进行调整，使其重新成为大顶堆
            heapAdjust(items: &list, startIndex: 0, endIndex: endIndex + 1)
        }
        
        return list
    }
    
    func heapCreate(arr: inout [Int]) {
        var count = arr.count
        while count > 0 {
            heapAdjust(items: &arr, startIndex: count - 1, endIndex: arr.count)
            count -= 1
        }
    }
    
    func heapAdjust(items: inout [Int], startIndex: Int, endIndex: Int) {
        print("startIndex: \(startIndex)")
        let temp = items[startIndex]
        var fatherIndex = startIndex + 1    //父节点下标
        var maxChildIndex = 2 * fatherIndex //左孩子下标
        
        while maxChildIndex <= endIndex {
            //比较左右孩子并找出比较大的下标
            if maxChildIndex < endIndex && items[maxChildIndex - 1] < items[maxChildIndex] {
                maxChildIndex = maxChildIndex + 1
            }
            
            //如果较大的那个子节点比根节点大，就将该节点的值赋给父节点
            if temp < items[maxChildIndex - 1] {
                items[fatherIndex - 1] = items[maxChildIndex - 1]
            } else {
                break
            }
            fatherIndex = maxChildIndex
            maxChildIndex = 2 * fatherIndex
        }
        items[fatherIndex - 1] = temp
    }
}

//MARK: -
func sortedTwoArrays(a: [Int], b: [Int]) -> [Int] {
    var c = [Int](repeating: 0, count: a.count + b.count)
    var i = 0, j = 0, k = 0
    
    while i < a.count && j < b.count {
        if a[i] >= b[j] {
            c[k] = b[j]
            k += 1
            j += 1
        }else {
            c[k] = a[i]
            k += 1
            i += 1
        }
    }
    
    while i < a.count {
        c[k] = a[i]
        k += 1
        i += 1
    }
    
    while j < b.count {
        c[k] = b[j]
        k += 1
        j += 1
    }
    
    return c
}

//求两个长度相等有序数组的中位数
func getupMedian(arr1: [Int], arr2: [Int]) -> Int {
    if arr1.isEmpty || arr2.isEmpty {
        return -1
    }
    
    var l1 = 0, l2 = 0, mid1 = 0, mid2 = 0, offset = 0
    var r1 = arr1.count - 1, r2 = arr2.count - 1
    
    while l1 < r1 {
//        print("l1: \(l1), r1: \(r1), l2: \(l2), r2: \(r2)")
        mid1 = l1 + (r1 - l1)/2
        mid2 = l2 + (r2 - l2)/2
//        print("mid1: \(mid1), mid2: \(mid2)")
        offset = ((r1 - l1 + 1) & 1) ^ 1
//        print("offset: \(offset)")
        
        if arr1[mid1] < arr2[mid2] {
            l1 = mid1 + offset
            r2 = mid2
        }else if arr1[mid1] > arr2[mid2] {
            r1 = mid1
            l2 = mid2 + offset
        }else {
            return arr1[mid1]
        }
    }
    
    return min(arr1[l1], arr2[l2])
}
