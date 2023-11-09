package interview.huawei;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * <a href="https://zhuanlan.zhihu.com/p/662299546">Original Test Question</a>
 */
public class GoBangFan {
    private static final int[] simpleOne = {1, 0, 1, 1, 1, -1, 0, 0, 1};
//    private static final int[] simpleOne = {1, 0, 1, 1, -1, -1, 0, 1, 1};

    public static void main(String[] args) {
        Function<int[], Boolean> isOddFunc = arr -> arr.length % 2 == 1;
        Boolean isOdd = isOddFunc.apply(simpleOne);
        System.out.println("isOdd = " + isOdd);

        Function<int[], Long> countZero = arr -> Arrays.stream(arr).filter(n -> n == 0).count();
        Long count = countZero.apply(simpleOne);
        System.out.println("count = " + count);

        HashMap<Integer, Integer> indexMaxSpan = getIndexMaxSpanForEachIndex(simpleOne, 1);
        System.out.println("indexMaxSpan = " + indexMaxSpan);

        int index = getTheMostSuitableIndexToDropPawn(indexMaxSpan);
        System.out.println("index = " + index);
    }

    private static int getTheMostSuitableIndexToDropPawn(HashMap<Integer, Integer> indexMaxSpan) {
        TreeMap<Integer, List<Integer>> duplicatedMaxSpanIndexes = findTheDuplicatedSpanEntrySet(indexMaxSpan);
        if (duplicatedMaxSpanIndexes != null && !duplicatedMaxSpanIndexes.isEmpty()) {
            Integer maxSpan = duplicatedMaxSpanIndexes.lastKey();
            List<Integer> indexes = duplicatedMaxSpanIndexes.get(maxSpan);
            return indexes.stream().mapToInt(Integer::intValue).max().orElse(0);
        }else{
            Optional<Map.Entry<Integer, Integer>> max = indexMaxSpan.entrySet()
                    .stream()
                    .max(Map.Entry.comparingByValue());
            if(max.isPresent()){
                Map.Entry<Integer, Integer> entry = max.get();
                return entry.getKey();
            }else{
                return -1;
            }
        }
    }

    private static TreeMap<Integer, List<Integer>> findTheDuplicatedSpanEntrySet(HashMap<Integer, Integer> indexMaxSpan) {
        return indexMaxSpan.entrySet()
                .stream()
                .collect(Collectors.groupingBy(
                        Map.Entry::getValue,
                        Collectors.mapping(Map.Entry::getKey, Collectors.toList())
                ))
                .entrySet()
                .stream()
                .filter(entry -> entry.getValue().size() > 1)
                .collect(
                        Collectors.toMap(
                                Map.Entry::getKey,
                                Map.Entry::getValue,
                                (o, n) -> o,
                                TreeMap::new
                        )
                );
    }

    private static HashMap<Integer, Integer> getIndexMaxSpanForEachIndex(int[] line, int currentPawn) {
        HashMap<Integer, Integer> indexByMaxSpan = new HashMap<>();
        for (int i = 0; i < line.length; i++) {
            if (line[i] == 0) {
                int leftCount = 0;
                int leftCur = i - 1;
                while (leftCur >= 0 && line[leftCur] == currentPawn) {
                    leftCur--;
                    leftCount++;
                }
                int rightCount = 0;
                int rightCur = i + 1;
                while (rightCur < line.length && line[rightCur] == currentPawn) {
                    rightCur++;
                    rightCount++;
                }
                int maxSpan = leftCount + rightCount;
                indexByMaxSpan.put(i, maxSpan);
            }
        }
        return indexByMaxSpan;
    }
}
