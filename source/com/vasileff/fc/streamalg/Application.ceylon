"Simulate Type-Constructor Polymorphism
    `T` is a type parameter of the target class
    `C` is a marker class for the target class"
shared suppressWarnings("unusedDeclaration")
interface Application<C, out T> {}