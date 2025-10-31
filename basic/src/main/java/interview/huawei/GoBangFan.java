package interview.huawei;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static java.util.Map.*;

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

        HashMap<Integer, Integer> indexMaxSpan = getIndexMaxSpanForEachIndex();
        System.out.println("indexMaxSpan = " + indexMaxSpan);

        int index = getTheMostSuitableIndexToDropPawn(indexMaxSpan);
        System.out.println("index = " + index);
    }

    /**
     * @param indexMaxSpan which means there are equal case when we should put the pawn in the one index that most near the mid-point of the pawn line
     * @return the nearest index position when there are many equal span cases.
     */
    private static int getIndexNearToTheMiddle(TreeMap<Integer, List<Integer>> indexMaxSpan) {
        final int midPoint = (int) (0.5 * (GoBangFan.simpleOne.length - 1));
        Entry<Integer, List<Integer>> integerListEntry = indexMaxSpan
                .entrySet()
                .stream()
                .min(
                        Comparator.comparingInt(entry -> Math.abs(entry.getKey() - midPoint))
                )
                .orElseThrow();
        return integerListEntry.getKey();
    }

    private static int getTheMostSuitableIndexToDropPawn(HashMap<Integer, Integer> indexMaxSpan) {
        TreeMap<Integer, List<Integer>> duplicatedMaxSpanIndexes = findTheDuplicatedSpanEntrySet(indexMaxSpan);
        if (duplicatedMaxSpanIndexes != null && !duplicatedMaxSpanIndexes.isEmpty()) {
            Integer maxSpan = duplicatedMaxSpanIndexes.lastKey();
            List<Integer> indexes = duplicatedMaxSpanIndexes.get(maxSpan);
            int midIndex = getIndexNearToTheMiddle(duplicatedMaxSpanIndexes);
            return indexes.stream().mapToInt(Integer::intValue).max().orElse(midIndex);
        } else {
            Optional<Map.Entry<Integer, Integer>> maxEntry = indexMaxSpan.entrySet()
                    .stream()
                    .max(Entry.comparingByValue());
            if (maxEntry.isPresent()) {
                Map.Entry<Integer, Integer> entry = maxEntry.get();
                return entry.getKey();
            } else {
                return -1;
            }
        }
    }

    private static TreeMap<Integer, List<Integer>> findTheDuplicatedSpanEntrySet(HashMap<Integer, Integer> indexMaxSpan) {
        return indexMaxSpan.entrySet()
                .stream()
                .collect(Collectors.groupingBy(
                        Entry::getValue,
                        Collectors.mapping(Entry::getKey, Collectors.toList())
                ))
                .entrySet()
                .stream()
                .filter(entry -> entry.getValue().size() > 1)
                .collect(
                        Collectors.toMap(
                                Entry::getKey,
                                Entry::getValue,
                                (o, n) -> o,
                                TreeMap::new
                        )
                );
    }

    private static HashMap<Integer, Integer> getIndexMaxSpanForEachIndex() {
        HashMap<Integer, Integer> indexByMaxSpan = new HashMap<>();
        for (int i = 0; i < GoBangFan.simpleOne.length; i++) {
            if (GoBangFan.simpleOne[i] == 0) {
                int leftCount = 0;
                int leftCur = i - 1;
                while (leftCur >= 0 && GoBangFan.simpleOne[leftCur] == 1) {
                    leftCur--;
                    leftCount++;
                }
                int rightCount = 0;
                int rightCur = i + 1;
                while (rightCur < GoBangFan.simpleOne.length && GoBangFan.simpleOne[rightCur] == 1) {
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
