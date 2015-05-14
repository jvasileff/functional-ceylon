"Interface for pull style streams"
shared
interface Pull<out Element>
        satisfies Iterator<Element> {}
