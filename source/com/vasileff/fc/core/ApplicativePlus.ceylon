shared
interface ApplicativePlus<Box>
        satisfies Applicative<Box> &
                  PlusEmpty<Box>
        given Box<out E> {}