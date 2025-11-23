function validate(sol::BinPackingSolution, inst::BinPacking)
   if length(sol.assignment) != length(inst.elements)
      return false
   end

   sums = zeros(typeof(inst.bin_size), inst.bins)

   for (i, b) in enumerate(sol.assignment)
      sums[b] += inst.elements[i]
   end

   return all(x -> x <= inst.bin_size, sums)
end

function transform(inst::Partition{T}, target::Type{BinPacking}) where T<:Integer
   v = _safehalf(sum(inst.elements))
   return BinPacking(inst.elements, 2, T(v))
end

function extract(sol::BinPackingSolution, parent::Partition)
   return PartitionSolution(Set(findall(x -> x == 1, sol.assignment)))
end

function construct(target::Type{BinPackingSolution}, sol::PartitionSolution, parent::Partition)
   return BinPackingSolution([i ∈ sol.subset ? 1 : 2 for i in eachindex(parent.elements)])
end