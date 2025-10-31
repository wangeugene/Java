package interview.huawei;

import java.util.Arrays;
import java.util.List;
import java.util.TreeMap;
import java.util.stream.Collectors;

final class MemoryAllocation {
    private static final String memoryStorage = "64:2,128:1,32:4,1:128";
    private static final String memoryRequest = "50,36,64,128,127";

    public static void main(String[] args) {
        TreeMap<Integer, Integer> sizeCounts = getMemoryStorage();
        System.out.println("sizeCounts = " + sizeCounts);
        List<Integer> requests = getMemoryRequest();
        System.out.println("requests = " + requests);

        for (Integer request : requests) {
            boolean allocated = allocateRecursively(sizeCounts, request);
            System.out.println(allocated);
        }
        System.out.println("sizeCounts = " + sizeCounts);
    }

    private static boolean allocateRecursively(TreeMap<Integer, Integer> sizeCounts, Integer request) {
        Integer ceilingKey = sizeCounts.ceilingKey(request);
        if (ceilingKey == null) {
            return false;
        }
        Integer ceilingKeyCount = sizeCounts.get(ceilingKey);
        // refactor the block below
        if (ceilingKeyCount > 0) {
            ceilingKeyCount--;
            if (ceilingKeyCount == 0) {
                sizeCounts.remove(ceilingKey);
            } else {
                sizeCounts.put(ceilingKey, ceilingKeyCount);
            }
            return true;
        }
        return false;
    }

    private static List<Integer> getMemoryRequest() {
        return Arrays.stream(MemoryAllocation.memoryRequest.split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());
    }

    private static TreeMap<Integer, Integer> getMemoryStorage() {
        TreeMap<Integer, Integer> sizeCounts = new TreeMap<>();
        Arrays.stream(MemoryAllocation.memoryStorage.split(","))
                .map(p -> p.split(":"))
                .forEach(p -> sizeCounts.put(Integer.parseInt(p[0]), Integer.parseInt(p[1])));
        return sizeCounts;
    }
}
